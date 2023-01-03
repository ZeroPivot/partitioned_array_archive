# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Style/RedundantReturn
# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/IfInsideElse
# rubocop:disable Style/IfUnlessModifier
# rubocop:disable Style/NegatedIf
# rubocop:disable Style/GuardClause
# rubocop:disable Layout/LineLength
# rubocop:disable Style/StringConcatenation
# rubocop:disable Layout/SpaceAroundOperators
# rubocop:disable Metrics/ClassLength
# rubocop:disable Style/StringLiterals
# rubocop:disable Style/MutableConstant
# rubocop:disable Metrics/ParameterLists
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Layout/HashAlignment
# rubocop:disable Layout/ArgumentAlignment
require_relative 'file_context_managed_partitioned_array'

# TODO: (1/3/2023 - 12:55PM)
# set a timestamp in the databases per transaction
# relational algebraic operations (cartesian product, etc.)
# VERSION v2.0.1a - prettify, remove old unused code; alias (1/3/2023 12:54PM)
# alias db_table database_table
# alias active_db active_database
# alias new_db! new_database! 
# VERSION v2.0.0a - Got the basics of the database table working, all works (1/3/2023)
# Defined Methods:
# FCMPAM#database(database_name = @active_database): returns the database object
# FCMPAM#database_table(database_name: @active_database, database_table: @active_table): returns the database table object
# FCMPAM#new_database!(database_name): creates a new database
# FCMPAM#new_table!(database_name:, database_table:): creates a new table in the database
# FCMPAM#active_database(database_name): sets the active database
# FCMPAM#active_table(database_table): sets the active table
# FCMPAM#table(database_table = @active_table): returns the active table
# FCMPAM#database(database_name = @active_database): returns the active database

# save_everything_to_files!: saves everything to files
# load_everything_from_files!: loads everything from files

# VERSION v1.0.3 - got man_db to contain the many tables of its own
# VERSION v1.0.2a - working on new_database, where the database table entries have to contain an array of the tables, so the database knows which tables belong to it
# VERSION v1.0.1a - -left off at line 169
# VERSION v0.1.0a - BASICS are working, in new_database_test (12/6/2022 - 8:14am)
# VERSION v0.0.6
# VERSION v0.0.5

# FileContextManagedPartitionedArrayManager - manages the FileContextManagedPartitionedArray and its partitions, making the Partitioned Array a database with database IDs
# and table keys
class FileContextManagedPartitionedArrayManager
  attr_accessor :fcmpa_db_indexer_db, :fcmpa_active_databases, :db_file_incrementor, :db_file_location, :db_path, :db_name, :db_size, :db_endless_add, :db_has_capacity, :fcmpa_db_indexer_name, :fcmpa_db_folder_name, :fcmpa_db_size, :fcmpa_partition_amount_and_offset, :db_partition_amount_and_offset, :partition_addition_amount, :db_dynamically_allocates, :timestamp_str

  # DB_SIZE > PARTITION_AMOUNT
  TRAVERSE_HASH = true
  FCMPA_PARTITION_AMOUNT = 9
  FCMPA_OFFSET = 1
  FCMPA_DB_ENDLESS_ADD = true
  FCMPA_DB_DYNAMICALLY_ALLOCATES = true
  FCMPA_DB_PARTITION_ADDITION_AMOUNT = 5
  FCMPA_DB_HAS_CAPACITY = true
  FCMPA_DB_MAX_CAPACITY = "data_arr_size"
  FCMPA_DB_INDEXER_NAME = "FCMPA_DB_INDEX"
  FCMPA_DB_FOLDER_NAME = "./DB/FCMPAM_DB_INDEX"
  FCMPA_DB_PARTITION_ARCHIVE_ID = 0
  FCMPA_DB_SIZE = 20
  FCMPA_DB_INDEX_LOCATION = 0
  FCMPA_DB_TRAVERSE_HASH = true

  # FCMPA_DB_[type]
  DB_PARTITION_AMOUNT = 9
  DB_PARTITION_OFFSET = 1
  DB_NAME = "FCMPA_DB"
  DB_PATH = "./DB/FCMPAM_DB"
  DB_HAS_CAPACITY = true
  DB_DYNAMICALLY_ALLOCATES = true
  DB_ENDLESS_ADD = true
  DB_MAX_CAPACITY = "data_arr_size"
  DB_PARTITION_ARCHIVE_ID = 0
  DB_SIZE = 20
  DB_PARTITION_ADDITION_AMOUNT = 5
  DB_TRAVERSE_HASH = true

  INITIAL_AUTOSAVE = true
  # db
  # fcmpa
  # man_db

  def initialize(db_max_capacity: DB_MAX_CAPACITY,
                 db_size: DB_SIZE,
                 db_endless_add: DB_ENDLESS_ADD,
                 db_has_capacity: DB_HAS_CAPACITY,
                 db_name: DB_NAME,
                 db_path: DB_PATH,
                 db_partition_addition_amount: DB_PARTITION_ADDITION_AMOUNT,
                 db_dynamically_allocates: DB_DYNAMICALLY_ALLOCATES,   
                 db_partition_amount_and_offset: DB_PARTITION_AMOUNT + DB_PARTITION_OFFSET,
                 db_partition_archive_id: DB_PARTITION_ARCHIVE_ID,
                 db_traverse_hash: DB_TRAVERSE_HASH,
                 fcmpa_db_size: FCMPA_DB_SIZE,
                 fcmpa_db_indexer_name: FCMPA_DB_INDEXER_NAME,
                 fcmpa_db_index_location: FCMPA_DB_INDEX_LOCATION, 
                 fcmpa_db_folder_name: FCMPA_DB_FOLDER_NAME,
                 fcmpa_db_partition_amount_and_offset: FCMPA_PARTITION_AMOUNT + FCMPA_OFFSET,
                 fcmpa_db_has_capacity: FCMPA_DB_HAS_CAPACITY, 
                 fcmpa_db_partition_addition_amount: FCMPA_DB_PARTITION_ADDITION_AMOUNT,
                 fcmpa_db_dynamically_allocates: FCMPA_DB_DYNAMICALLY_ALLOCATES,
                 fcmpa_db_endless_add: FCMPA_DB_ENDLESS_ADD,
                 fcmpa_db_max_capacity: FCMPA_DB_MAX_CAPACITY,
                 fcmpa_db_partition_archive_id: FCMPA_DB_PARTITION_ARCHIVE_ID,
                 fcmpa_db_traverse_hash: FCMPA_DB_TRAVERSE_HASH,
                 initial_autosave: INITIAL_AUTOSAVE,
                 active_database: nil,
                 active_table: nil)

    @fcmpa_db_partition_archive_id = fcmpa_db_partition_archive_id
    @fcmpa_db_endless_add = fcmpa_db_endless_add
    @fcmpa_db_partition_amount_and_offset = fcmpa_db_partition_amount_and_offset
    @fcmpa_db_max_capacity = fcmpa_db_max_capacity
    @fcmpa_db_index_location = fcmpa_db_index_location
    @fcmpa_db_size = fcmpa_db_size
    @fcmpa_db_indexer_name = fcmpa_db_indexer_name
    @fcmpa_db_folder_name = fcmpa_db_folder_name
    @fcmpa_db_partition_addition_amount = fcmpa_db_partition_addition_amount
    @fcmpa_db_has_capacity = fcmpa_db_has_capacity
    @fcmpa_db_dynamically_allocates = fcmpa_db_dynamically_allocates
    @fcmpa_db_partition_addition_amount = fcmpa_db_partition_addition_amount
    @fcmpa_db_traverse_hash = fcmpa_db_traverse_hash

    # The database which holds all the entries that the manager database manages
    @db_has_capacity = db_has_capacity
    @db_endless_add = db_endless_add
    @db_size = db_size
    @db_path = db_path
    @db_name = db_name
    @db_dynamically_allocates = db_dynamically_allocates
    @db_partition_amount_and_offset = db_partition_amount_and_offset
    @db_max_capacity = db_max_capacity
    @db_partition_addition_amount = db_partition_addition_amount
    @db_partition_archive_id = db_partition_archive_id
    @db_traverse_hash = db_traverse_hash
    @initial_autosave = initial_autosave
    @active_table = active_table
    @active_database = active_database

    @timestamp_str = Time.now.strftime("%Y-%m-%d-%H-%M-%S")

    @man_index = FileContextManagedPartitionedArray.new(fcmpa_db_partition_amount_and_offset: @fcmpa_db_partition_amount_and_offset,
                                                        fcmpa_db_size: @fcmpa_db_size,
                                                        fcmpa_db_indexer_name: @fcmpa_db_indexer_name+"_"+"indexer",
                                                        fcmpa_db_folder_name: @fcmpa_db_folder_name+"_"+"indexer",
                                                        fcmpa_db_dynamically_allocates: @fcmpa_db_dynamically_allocates,
                                                        fcmpa_db_endless_add: @fcmpa_endless_add,
                                                        fcmpa_db_partition_addition_amount: @man_db_partition_addition_amount,
                                                        fcmpa_db_has_capacity: @fcmpa_db_has_capacity,
                                                        fcmpa_db_index_location: @fcmpa_db_index_location,
                                                        fcmpa_db_max_capacity: @fcmpa_db_max_capacity,
                                                        fcmpa_db_partition_archive_id: @fcmpa_db_partition_archive_id,
                                                        db_partition_addition_amount: @partition_addition_amount,
                                                        db_size: @db_size,
                                                        db_endless_add: @db_endless_add,
                                                        db_has_capacity: @db_has_capacity,
                                                        db_name: @db_name, # difference: man_indexer instead of man_db_
                                                        db_path: @db_path, #
                                                        db_dynamically_allocates: @db_dynamically_allocates,
                                                        db_partition_amount_and_offset: @db_partition_amount_and_offset,
                                                        db_max_capacity: @db_max_capacity,
                                                        db_partition_archive_id: @db_partition_archive_id,
                                                        traverse_hash: @traverse_hash)

    # a man_db entry for every single database table, while man_index maintains the link between the manager database and the database tables
    @man_db = FileContextManagedPartitionedArray.new(fcmpa_db_partition_amount_and_offset: @fcmpa_db_partition_amount_and_offset,
                                                        fcmpa_db_size: @fcmpa_db_size,
                                                        fcmpa_db_indexer_name: @fcmpa_db_indexer_name+"_"+"database",
                                                        fcmpa_db_folder_name: @fcmpa_db_folder_name+"_"+"database",
                                                        fcmpa_db_dynamically_allocates: @fcmpa_db_dynamically_allocates,
                                                        fcmpa_db_endless_add: @fcmpa_endless_add,
                                                        fcmpa_db_partition_addition_amount: @man_db_partition_addition_amount,
                                                        fcmpa_db_has_capacity: @fcmpa_db_has_capacity,
                                                        fcmpa_db_index_location: @fcmpa_db_index_location,
                                                        fcmpa_db_max_capacity: @fcmpa_db_max_capacity,
                                                        fcmpa_db_partition_archive_id: @fcmpa_db_partition_archive_id,
                                                        db_partition_addition_amount: @partition_addition_amount,
                                                        db_size: @db_size, #
                                                        db_endless_add: @db_endless_add, #
                                                        db_has_capacity: @db_has_capacity, #
                                                        db_name: @db_name, # difference: man_indexer instead of man_db_
                                                        db_path: @db_path, #
                                                        db_dynamically_allocates: @db_dynamically_allocates, #
                                                        db_partition_amount_and_offset: @db_partition_amount_and_offset, #
                                                        db_max_capacity: @db_max_capacity, #
                                                        db_partition_archive_id: @db_partition_archive_id, #
                                                        traverse_hash: @traverse_hash)
  end

  # gets the database object for the database_name (@man_index = database index; @man_db = database table)
  def database(database_name = @active_database)
    # check to see if this table exists in the database first
    return @man_index.db(database_name)
  end

  # gets the database table object for the database_table name, not needing a database x index pair
  def table(database_table = @active_table)
    return @man_db.db(database_table)
  end
  
  # set the active database table variable to avoid redundant typing
  def active_table(database_table)
    @active_table = database_table
  end
  
  # set the active database variable to avoid redundant typing
  def active_database(active_database)
    @active_database = active_database
  end
  # gets the database table object for the database_table name, needing a database x index pair
  def database_table(database_table: @active_table, database_name: @active_database)
    # check to see if this table exists in the database first
    if @man_index.db(database_name).get(0)[database_name]["db_table_name"].include? database_table
      return @man_db.db(database_table)
    end
    # if the table entry contains the table name in @man_index, then
  end

  # update: left off worrying about the db_table_name entry having to contain an array of the table names so that the database knows which tables to look for and which ones belong to it
  # left off working with new_table, and, setting the table apart from the database and placing them into independent folders (the problem is file locations)
  def new_table!(database_table:, database_name:, initial_autosave: @initial_autosave)
    @man_index.start_database!(database_name, db_path: @db_path+"/MAN_DB_INDEX/INDEX", only_path: true, only_name: true, db_name: "INDEX")
    @man_db.start_database!(database_table, db_path: @db_path+"/MAN_DB_TABLE/#{database_name}/TABLE", only_path: true, only_name: true, db_name: "TABLE")

    old_db_table_name = @man_index.db(database_name).get(0).dig(database_name, "db_table_name")
    if old_db_table_name.nil?
      @man_index.db(database_name).set(0) do |hash|
        hash[database_name] = { "db_name" => database_name, "db_path" => @db_path+"/DB_#{database_name}", "db_table_name" => [database_table] }
      end
    else
      if !old_db_table_name.include?(database_table)
        @man_index.db(database_name).set(0) do |hash|
          hash[database_name] = { "db_name" => database_name, "db_path" => @db_path+"/DB_#{database_name}", "db_table_name" => old_db_table_name << database_table }
        end
      else
        #puts "table already exists, not updating"
      end
    end

    @man_index.db(database_name).save_everything_to_files! if initial_autosave
    @man_db.db(database_table).save_everything_to_files! if initial_autosave
  end

  # the index is the database name, and man__db maintains the databases defined by the index
  def new_database!(database_name)
    @man_index.start_database!(database_name, db_path: @db_path+"/MAN_DB_INDEX/INDEX", only_path: true, only_name: false, db_name: "INDEX")
  end
  
  alias db_table database_table
  alias active_db active_database
  alias new_db! new_database! 
end




# rubocop:enable Layout/HashAlignment
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ParameterLists
# rubocop:enable Style/MutableConstant
# rubocop:enable Style/StringLiterals
# rubocop:enable Metrics/ClassLength
# rubocop:enable Layout/SpaceAroundOperators
# rubocop:enable Style/StringConcatenation
# rubocop:enable Layout/LineLength
# rubocop:enable Style/GuardClause
# rubocop:enable Style/NegatedIf
# rubocop:enable Style/IfUnlessModifier
# rubocop:enable Style/IfInsideElse
# rubocop:enable Style/FrozenStringLiteralComment
# rubocop:enable Style/RedundantReturn
# rubocop:enable Lint/RedundantCopDisableDirective
# rubocop:enable Style/FrozenStringLiteralComment
# rubocop:enable Lint/MissingCopEnableDirective
# rubocop:enable Lint/RedundantCopDisableDirective
