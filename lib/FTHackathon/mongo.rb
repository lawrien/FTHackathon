require 'mongo'
require 'mime/types'

module FTHackathon
    # class PKFactory
    #   def create_pk(row)
    #     return row if row[:_id]
    #     row.delete(:_id)      # in case it exists but the value is nil
    #     row[:_id] ||= (row[:id] || row['id'])
    #     row
    #   end
    # end

    module Mongo
      HOST = 'localhost'
      PORT = '27017'
      DATABASE = 'FTHack'

      def self.connection
        @_conn ||= ::Mongo::Connection.new(HOST,PORT)
      end

      def self.db
        # @_db ||= connection.db(DATABASE,:pk => PKFactory.new)
        @_db ||= connection.db(DATABASE)
      end

      def self.upsert(coll,hash)
        now = Time.now
        if (hash.has_key? "created_at")
          hash['updated_at'] = now
          db[coll].update({'_id' => hash['_id']}, hash)
          hash['_id']
        else
          hash['updated_at'] = now
          hash['created_at'] = now
          hash['_id'] = db[coll].insert(hash)
          hash['_id']
        end
      end

      def self.find(coll,query = {})
        db[coll].find(query)
      end

      ASCENDING = ::Mongo::ASCENDING
      DESCENDING = ::Mongo::DESCENDING
      GEO2D = ::Mongo::GEO2D

      def self.ensure_index(coll,spec)
        db[coll].ensure_index(spec)
      end

      def self.write_doc(coll,doc)
        doc = doc.to_hash unless doc.kind_of? Hash
        upsert(coll,doc)
      end
    end
  end
end
