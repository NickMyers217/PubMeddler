json.array!(@queries) do |query|
  json.extract! query, :id, :journal, :term, :retmax, :mindate, :maxdate
  json.url query_url(query, format: :json)
end
