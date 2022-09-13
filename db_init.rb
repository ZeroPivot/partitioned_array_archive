require 'json'
require 'fileutils'
require_relative "lib/managed_partitioned_array"
DB_SIZE = 20
PARTITION_AMOUNT = 4
OFFSET = 1
DEFAULT_PATH = './stress_test'
DB_NAME = 'stress_test'
MAX_CAPACITY=5

FileUtils.rm_rf(DEFAULT_PATH)
sl_db = ManagedPartitionedArray.new(max_capacity: 20, initial: true, db_size: DB_SIZE, partition_amount_and_offset: PARTITION_AMOUNT + OFFSET, db_path: DEFAULT_PATH, db_name: DB_NAME)
sl_db.allocate
sl_db.save_everything_to_files!
puts "done?"