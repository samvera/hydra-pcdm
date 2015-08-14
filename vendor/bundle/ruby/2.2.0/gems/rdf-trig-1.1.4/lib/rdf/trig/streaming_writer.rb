module RDF::TriG
  ##
  # Streaming writer interface
  # @author [Gregg Kellogg](http://greggkellogg.net/)
  module StreamingWriter
    ##
    # Write out a statement, retaining current
    # `subject` and `predicate` to create more compact output
    # @return [void] `self`
    def stream_statement(statement)
      if statement.context != @streaming_context
        stream_epilogue
        if statement.context
          @output.write "#{format_term(statement.context)} {"
        end
        @streaming_context, @streaming_subject, @streaming_predicate = statement.context, statement.subject, statement.predicate
        @output.write "#{format_term(statement.subject)} "
        @output.write "#{format_term(statement.predicate)} "
      elsif statement.subject != @streaming_subject
        @output.puts " ." if @previous_statement
        @output.write "#{indent(@streaming_subject ? 1 : 0)}"
        @streaming_subject, @streaming_predicate = statement.subject, statement.predicate
        @output.write "#{format_term(statement.subject)} "
        @output.write "#{format_term(statement.predicate)} "
      elsif statement.predicate != @streaming_predicate
        @streaming_predicate = statement.predicate
        @output.write ";\n#{indent(@streaming_subject ? 2 : 1)}#{format_term(statement.predicate)} "
      else
        @output.write ",\n#{indent(@streaming_subject ? 3 : 2)}"
      end
      @output.write("#{format_term(statement.object)}")
      @previous_statement = statement
    end

    ##
    # Complete open statements
    # @return [void] `self`
    def stream_epilogue
      case
      when @previous_statement.nil? ;
      when @streaming_context then @output.puts " }"
      else @output.puts " ."
      end
    end

    private
  end
end
