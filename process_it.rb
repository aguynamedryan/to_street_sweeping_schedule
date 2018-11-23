require "csv"
require "date"

month_headers = %i[jan feb mar apr may jun jul aug sep oct nov dec]
output_rows = CSV.foreach("complete.csv", headers: true, header_converters: :symbol).flat_map do |row|
  if month_headers.all? { |header| row[header] == "" }
    next
  end

  month_headers.flat_map do |month|
    row[month].split(/\s*&\s*/).map(&:to_i).flat_map do |day|
      row.to_hash.slice(:street_name, :dir, :suffix, :from__to).merge({ date: Date.parse("#{month} #{day}, 2018") })
    end
  end
end.compact

CSV.open("processed.csv", "w") do |csv|
  csv << output_rows.first.keys
  output_rows.each do |row|
    csv << row.values
  end
end
