Usage notes and comments follow (sorry for the length here, please read carefully).

Write failures:  there is a single type of write failure, and it occurs when 
an exception of some sort is raised during Heartbeat write.
This is the only type of write failure that can be detected. 
If :reliable is true, an exception on heartbeat write will always causes a fail 
over attempt.

Read failures:  this is actually more complex than originally envisioned. 
There are really three distinct types of read 'failures':

1) An exception is thrown during Heartbeat read.  If :reliable is true, this 
   always causes a fail over attempt.

2) Heartbeat reads can not obtain the read_semaphore lock.  This will occur 
   when the main connection thread has:
    -- Called Connection#receive
    -- Only heartbeats but no Stomp frames are on the inbound wire
    -- Last Heartbeat read time is being maintained by the #receive attempt

3) Heartbeat reads obtain the read_semaphore lock, but the socket shows no 
   data is available (by IO#ready?).  This will occur when:
    -- The main thread has not called Connection#receive (the thread is doing other work)
    -- There is no heartbeat to receive (IO#ready? indicates no input data available)

The requirement to handle cases 2) and 3) results in not one, but two different 
counters being taken in to consideration.

To handle case 2) add to the connect hash:

:max_hbrlck_fails => x # x is a number strictly greater than 0.  Default is 0, 
which disables the functionality.

A running count of this failure type is maintained in the HB read thread.  The 
count is incremented when:

-- Lock obtain fails, *and*
-- A heartbeat is 'late'

The count is reset to 0 whenever:

-- A heart beat has been received on a timely basis

When the running count *reaches* the value specified in :max_hbrlck_fails, a 
fail over attempt is initiated.

Advice:  do *not* set this to 1 (in order to avoid fail overs on a transient 
error).

To handle case 3) add to the connect hash:

:max_hbread_fails => y # y is a number strictly greater than 0.  Default is 0, 
which disables the functionality.

A running count of this failure type is maintained in the HB read thread.  
The count is incremented when:

-- Lock obtain succeeds, *and*
-- IO#ready? indicates no data available

The count is reset to 0 under two conditions:

Condition 1)
  --  A heartbeat is late, *and*
  -- Lock obtain succeeds, *and*
  -- IO#ready? indicates data is available, *and*
  -- A single character is read from the wire

Condition 2)
  -- A heartbeat has been received in a timely manner (perhaps by the main thread)

When the running count *reaches* the value specified in :max_hbread_fails, 
a fail over attempt is initiated.

Advice:  do *not* set this to 1 (in order to avoid fail overs on a transient 
error).

-----------------------------------------------------------

General advice:

Set your heartbeat intervals to the maximum possible to obtain your desired
behavior.  Do *not* set them at extremely low values even if the broker allows
that.  An absurd example:

heart-beat:1,1

which will likely not work well.

-----------------------------------------------------------

General notes:

In your real world apps, think about whether one or both of these parameters 
are appropriate.

Please add the:

-- on_hbread_fail
-- on_hbwrite_fail

methods to a callback logger.  In those methods show 'ticker_data.inspect' 
output.  We would want that log output in future problem reports.

We make the comment about not setting these values to 1 because every server 
we test with is prone to transient (single event) failures, particularly for 
client HB reads.

We have done a variety of informal tests here, using both server kill and 
packet drop strategies as appropriate.  We believe more real world testing is
required.

-----------------------------------------------------------

08/07/2013

Issue #63 related, specifically fast send heart beats are being used and 
spurious fail overs occur in rapid succession.

Background:

Fail over from heartbeat failures was introduced in gem version 1.2.10.

Subsequently:

This issue has been observed and documented in the following environment:

-- JRuby engine 1.7.4 *and*
-- ActiveMQ 5.8.0 *and*
-- 'fast' client send heartbeats

Heartbeat sends were at 2000ms.

At this point in time, fast send heart beats and spurious fail overs have 
*not* been observed using:

-- Any native RUBY_ENGINE and ActiveMQ
-- Any native RUBY_ENGINE and Apollo (client send rates are limited by default)
-- Any native RUBY_ENGINE and RabbitMQ
-- JRuby and Apollo (client send rates are limited by default)
-- JRuby and RabbitMQ

Note that 'fast' will depend on your use case for heartbeats.  Observations
are that sending heartbeat times less than 5000ms might be considered 'fast'
in the targeted environment.

The solution / bypass being put in place as of the above date was developed
through experimentation and is as follows:

- Add 'adjustment' logic to the heartbeat sender (thanks to ppaul for this idea).
- Re-introduce tolerance logic removed in d922fa.
- Add a new connection hash parameter to adjust heartbeat sends.

The newly introduced connection hash parameter is:

:fast_hbs_adjust => 0.0 # The default, no adjustment to sender sleep times (sec)

Recommendation for gem users that:

- Use fast send heartbeats
- Actually notice spurious fail overs

is to provide a very sender sleep time adjustment when connecting.  Examples:

:fast_hbs_adjust => 0.05 # 50 milliseconds
:fast_hbs_adjust => 0.10 # 100 milliseconds

As usual, YMMV.

