require_relative 'file_context_managed_partitioned_array'

# VERSION v0.0.6
# VERSION v0.0.5

class FileContextManagedPartitionedArrayManager
  
  attr_accessor :data_arr, :fcmpa_db_indexer_db, :fcmpa_active_databases, :active_database, :db_file_incrementor, :db_file_location, :db_path, :db_name, :db_size, :db_endless_add, :db_has_capacity, :fcmpa_db_indexer_name, :fcmpa_db_folder_name, :fcmpa_db_size, :fcmpa_partition_amount_and_offset, :db_partition_amount_and_offset, :partition_addition_amount, :db_dynamically_allocates, :timestamp_str
 
  # DB_SIZE > PARTITION_AMOUNT
  PARTITION_AMOUNT = 9 # The initial, + 1
  FCMPA_PARTITION_AMOUNT = 9
  FCMPA_OFFSET = 1
  OFFSET = 1 # This came with the math, but you can just state the PARTITION_AMOUNT in total and not worry about the offset in the end
  DB_SIZE = 20 # Caveat: The DB_SIZE is the total # of partitions, but you subtract it by one since the first partition is 0, in code. that is, it is from 0 to DB_SIZE-1, but DB_SIZE is then the max allocated DB size
  FCMPA_DB_SIZE = 20
  PARTITION_ARCHIVE_ID = 0
  DEFAULT_PATH = "./DB_TEST" # default fallback/write to current path
  DEBUGGING = false
  PAUSE_DEBUG = false
  #DB_NAME = 'partitioned_array_slice'
  PARTITION_ADDITION_AMOUNT = 5
  MAX_CAPACITY = "data_arr_size" # : :data_arr_size; a keyword to add to the array until its full with no buffer additions
  HAS_CAPACITY = true # if false, then the max_capacity is ignored and at_capacity? raises if @has_capacity == false
  DYNAMICALLY_ALLOCATES = true


  TRAVERSE_HASH = true
  FCMPA_DB_ENDLESS_ADD = true
  FCMPA_DB_DYNAMICALLY_ALLOCATES = true
  FCMPA_DB_PARTITION_ADDITION_AMOUNT = 5
  FCMPA_DB_HAS_CAPACITY = true
  FCMPA_DB_MAX_CAPACITY = "data_arr_size"
  FCMPA_DB_INDEXER_NAME = "FCMPA_DB_INDEX"
  FCMPA_DB_FOLDER_NAME = "./DB/FCMPA_DB"
  FCMPA_DB_PARTITION_ARCHIVE_ID = 0
  FCMPA_DB_SIZE = 20

  DB_PARTITION_AMOUNT = 9
  DB_PARTITION_OFFSET = 1
  DB_NAME = "fcmpa_db"
  DB_PATH = "./DB/FCMPA"
  DB_HAS_CAPACITY = true
  DB_DYNAMICALLY_ALLOCATES = true
  DB_ENDLESS_ADD = true
  DB_MAX_CAPACITY = "data_arr_size"
  DB_PARTITION_ARCHIVE_ID = 0
  DB_SIZE = 20

  MAN_DB_PARTITION_AMOUNT = 9
  MAN_DB_OFFSET = 1
  MAN_DB_SIZE = 20
  MAN_DB_HAS_CAPACITY = true
  MAN_DB_DYNAMICALLY_ALLOCATES = true
  MAN_DB_ENDLESS_ADD = true
  MAN_DB_INDEX_LOCATION = 0
  MAN_DB_ENDLESS_ADD = true
  MAN_DB_PARTITION_ADDITION_AMOUNT = 5
  MAN_DB_HAS_CAPACITY = true
  MAN_DB_MAX_CAPACITY = "data_arr_size"
  MAN_DB_INDEXER_NAME = "MAN_INDEX_DB" 
  MAN_DB_INDEXER_PATH = "./DB/MAN_INDEX_DB"
  MAN_DB_PARTITION_ARCHIVE_ID = 0

  

  def initialize(
                 db_max_capacity: DB_MAX_CAPACITY,
                 db_size: DB_SIZE,
                 db_endless_add: DB_ENDLESS_ADD,
                 db_has_capacity: DB_HAS_CAPACITY,
                 db_name: DB_NAME,
                 db_path: DB_PATH,
                 db_partition_addition_amount: DB_PARTITION_ADDITION_AMOUNT,
                 db_dynamically_allocates: DB_DYNAMICALLY_ALLOCATES,   
                 db_partition_amount_and_offset: DB_PARTITION_AMOUNT + DB_PARTITION_OFFSET,
                 db_partition_archive_id: DB_PARTITION_ARCHIVE_ID,
                 fcmpa_db_size: FCMPA_DB_SIZE,
                 fcmpa_db_indexer_name: FCMPA_DB_INDEXER_NAME,                
                 fcmpa_db_index_location: FCMPA_DB_INDEX_LOCATION,       
                 fcmpa_db_folder_name: FCMPA_DB_FOLDER_NAME,
                 fcmpa_db_partition_amount_and_offset: FCMPA_PARTITION_AMOUNT + FCMPA_OFFSET,
                 fcmpa_db_has_capacity: FCMPA_DB_HAS_CAPACITY, 
                 fcmpa_db_partition_addition_amount: FCMPA_DB_PARTITION_ADDITION_AMOUNT,
                 fcmpa_db_dynamically_allocates: FCMPA_DB_DYNAMICALLY_ALLOCATES,
                 fcmpa_db_endless_add: FCMPA_ENDLESS_ADD,
                 fcmpa_db_max_capacity: FCMPA_DB_MAX_CAPACITY, 
                 fcmpa_db_partition_archive_id: FCMPA_DB_PARTITION_ARCHIVE_ID,         
                 man_db_offset: MAN_DB_OFFSET,
                 man_db_size: MAN_DB_SIZE,
                 man_db_indexer_name: MAN_DB_INDEXER_NAME,
                 man_db_folder_name: MAN_DB_FOLDER_NAME,
                 man_db_has_capacity: MAN_DB_HAS_CAPACITY,
                 man_db_dynamically_allocates: MAN_DB_DYNAMICALLY_ALLOCATES,
                 man_db_endless_add: MAN_DB_ENDLESS_ADD,
                 man_db_partition_addition_amount: MAN_DB_PARTITION_ADDITION_AMOUNT,
                 man_db_partition_amount_and_offset: MAN_PARTITION_AMOUNT + MAN_OFFSET,                 
                 man_db_indexer_path: MAN_DB_INDEXER_PATH,
                 man_db_partition_archive_id: MAN_DB_PARTITION_ARCHIVE_ID,
                 man_db_max_capacity: MAN_DB_MAX_CAPACITY
                 )
          
    @fcmpa_db_partition_archive_id = fcmpa_db_partition_archive_id
    @fcmpa_db_endless_add = fcmpa_db_endless_add
    @fcmpa_db_partition_amount_and_offset = fcmpa_db_partition_amount_and_offset
    @fcmpa_db_max_capacity = fcmpa_db_max_capacity
    @fcmpa_db_index_location = fcmpa_db_index_location
    @fcmpa_db_size = fcmpa_db_size
    @fcmpa_db_indexer_name = fcmpa_db_indexer_name
    @fcmpa_db_folder_name = fcmpa_db_folder_name
    @fcmpa_db_endless_add = fcmpa_endless_add
    @fcmpa_db_partition_addition_amount = fcmpa_partition_addition_amount
    @fcmpa_db_has_capacity = fcmpa_db_has_capacity
    @fcmpa_db_dynamically_allocates = fcmpa_db_dynamically_allocates
    @fcmpa_db_partition_addition_amount = fcmpa_db_partition_addition_amount

    
    # The database which holds all the entries that the manager database manages
    @db_has_capacity = db_has_capacity
    @db_endless_add = db_endless_add    
    @db_size = db_size
    @db_path = db_path
    @db_name = db_name
    @db_dynamically_allocates = db_dynamically_allocates
    @db_partition_amount_and_offset =  db_partition_amount_and_offset
    @db_max_capacity = db_max_capacity
    @db_partition_addition_amount = db_partition_addition_amount
    @db_location = db_indexer_location
    @db_partition_archive_id = db_partition_archive_id
    # manager database /aritywolf/gallery,etc #=> in this case, aritywolf is the manager of gallery,etc
    @man_db_offset = man_db_offset
    @man_db_partition_amount = man_db_partition_amount
    @man_db_size = man_db_size
    @man_db_folder_name = man_db_folder_name
    @man_db_has_capacity = man_db_has_capacity
    @man_db_dynamically_allocates = man_db_dynamically_allocates
    @man_db_endless_add = man_db_endless_add
    @man_db_partition_addition_amount = man_db_partition_addition_amount
    @man_db_partition_amount_and_offset = man_db_partition_amount_and_offset
    @man_db_indexer_name = man_db_indexer_name
    @man_db_indexer_path = man_db_indexer_path
    @man_db_partition_archive_id = man_db_partition_archive_id
    @man_db_max_capacity = man_db_max_capacity
    @timestamp_str = Time.now.strftime("%Y-%m-%d-%H-%M-%S")

    @man_index = FileContextManagedPartitionedArray.new(fcmpa_db_partition_amount_and_offset: @fcmpa_db_partition_amount_and_offset,
                                                        fcmpa_db_size: @fcmpa_db_size,
                                                        fcmpa_db_indexer_name: @fcmpa_db_indexer_name,
                                                        fcmpa_db_folder_name: @fcmpa_db_folder_name,
                                                        fcmpa_db_dynamically_allocates: @fcmpa_db_dynamically_allocates,
                                                        fcmpa_endless_add: @fcmpa_endless_add,
                                                        fcmpa_partition_addition_amount: @man_db_partition_addition_amount,
                                                        fcmpa_db_has_capacity: @fcmpa_db_has_capacity,
                                                        fcmpa_db_index_location: @fcmpa_db_index_location,                                                    
                                                        fcmpa_db_max_capacity: @fcmpa_db_max_capacity,  
                                                        db_partition_addition_amount: @partition_addition_amount,
                                                        db_size: @db_size,
                                                        db_endless_add: @db_endless_add,
                                                        db_has_capacity: @db_has_capacity,
                                                        db_name: @db_name, #difference: man_indexer instead of man_db_
                                                        db_path: @db_path, #                                                       
                                                        db_dynamically_allocates: @db_dynamically_allocates,
                                                        db_partition_amount_and_offset: @db_partition_amount_and_offset,
                                                        db_max_capacity: @db_max_capacity,
                                                        )

    @man_db = FileContextManagedPartitionedArray.new(fcmpa_partition_amount_and_offset: @fcmpa_partition_amount_and_offset,
                                                    fcmpa_db_size: @fcmpa_db_size,
                                                    fcmpa_db_indexer_name: @fcmpa_db_indexer_name,
                                                    fcmpa_db_folder_name: @fcmpa_db_folder_name,
                                                    fcmpa_db_index_location: @fcmpa_db_index_location,
                                                    fcmpa_db_dynamically_allocates: @fcmpa_db_dynamically_allocates,
                                                    fcmpa_endless_add: @fcmpa_endless_add,
                                                    fcmpa_partition_addition_amount: @man_db_partition_addition_amount,
                                                    traverse_hash: @traverse_hash,
                                                    partition_addition_amount: @partition_addition_amount,
                                                    db_size: @man_db_size,
                                                    db_endless_add: @man_db_endless_add,
                                                    db_has_capacity: @man_db_has_capacity,
                                                    db_name: @man_db_indexer_name,
                                                    db_path: @man_db_path,                                                   
                                                    db_partition_addition_amount: @man_db_partition_addition_amount,
                                                    db_dynamically_allocates: @man_db_dynamically_allocates,
                                                    db_partition_amount_and_offset: @man_db_partition_amount_and_offset,
                                                    fcmpa_db_has_capacity: @man_fcmpa_db_has_capacity,
                                                    db_max_capacity: @db_max_capacity,
                                                    fcmpa_db_max_capacity: @fcmpa_db_max_capacity)


  end

  def man(database_name = "default")
    if !@man_index[database_name]
      # initialize database
      #@man_index[database_name]
      @man_db.new_database(database_name)
      
    else
      @man_db[database_name]
    end

  end

  




end