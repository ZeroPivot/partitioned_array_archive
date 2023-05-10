require_relative "lib/line_db"
require_relative "lib/line_reader"
require_relative "lib/line_database"



create_db_list_file_mkdir
write_lines(["test"])

test = LineDB.new(db_size: 2, database_partition_amount: 1)
test["test"].db.new_table!(database_name: "test_database", database_table: "test_table")

$incrementor = 0
a= Time.now
80.times do |i|
test["test"].db["test_database", "test_table"].add do |hash|  # benchmark with no saves and no additional processing
  hash["database_name"] = "test_database"
  hash["database_table"] = "test_table"
  hash["data"] = "test_data"
  hash["id"] = $incrementor
  puts $incrementor
  $incrementor += 1
end
end

test["test"].db["test_database", "test_table"].delete_partition!(1)
test["test"].db["test_database", "test_table"].save_everything_to_files!
b = Time.now
puts b-a

0..90.times do |i|
  p test["test"].db["test_database", "test_table"].get(i)
  puts "\n\n\n\n\n"
end