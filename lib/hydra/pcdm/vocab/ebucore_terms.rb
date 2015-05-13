require 'rdf'
module EBUCoreVocabularies
  class EBUCoreTerms < RDF::StrictVocabulary("http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#")
    # Property definitions
    property :filename,
      comment: ["The name of the file containing the Resource.".freeze],
      domain: "ebucore:Resource".freeze,
      range: "xsd:string".freeze,
      label: "File Name".freeze

    property :fileSize,
      comment: ["Size of a MediaResource in bytes.".freeze],
      domain: "ebucore:Resource".freeze,
      range: "xsd:integer".freeze,
      label: "File Size".freeze

    property :dateCreated,
      comment: ["The date of creation of the media resource.".freeze],
      domain: "ebucore:Resource".freeze,
      range: "xsd:dateTime".freeze,
      label: "Date Created".freeze

    property :hasMimeType,
      comment: ["Has Mime Type.".freeze],
      range: "xsd:string".freeze,
      label: "Has Mime Type".freeze

    property :dateModified,
      comment: ["To indicate the date at which the media resource has been modified.".freeze],
      range: "xsd:dateTime".freeze,
      label: "Date Modified".freeze  
  end
end