require "immosquare-extensions"

namespace :immosquare_extensions do
  namespace :sample do
    ##============================================================##
    ## bundle exec rake immosquare_extensions:sample:hash
    ##============================================================##
    task :depth do
      hash = {:a => 1, :b => {:c => 2, :d => {:e => 3}}}
      puts hash.depth
    end

    task :sort_by_key do
      hash = {:b => 1, :a => {:d => 4, :c => 3}}
      puts hash.sort_by_key
      puts hash.sort_by_key(:recursive => false)
    end


    ##============================================================##
    ## bundle exec rake immosquare_extensions:sample:json
    ##============================================================##
    task :json do
      hash1 = {:key => "abc", :key_2 => "abc\r\ndef", :key_3 => "abc\r\ndef\n\"ghi\"\tjkl", :key_abcdef => 2, :b => {:c => 2, :d_abcd => {:e => 3}}}
      hash2 = {
        :id       => 123_456,
        :name     => "John Doe",
        :active   => true,
        :count    => nil,
        :address  => {
          :street      => "1234 Elm Street",
          :city        => "Metropolis",
          :state       => "DC",
          :postal_code => "12345",
          :coordinates => {
            :lat  => 34.123,
            :long => -118.456
          }
        },
        :tags     => ["developer", "blogger", "chef"],
        :projects => [
          {
            :title       => "Project A",
            :description => "Description for project A",
            :tasks       => [
              "Task 1",
              "Task 2",
              "Task 3"
            ]
          },
          {
            :title       => "Project B",
            :description => "Description for project B",
            :tasks       => [
              "Task A",
              "Task B",
              "Task C"
            ]
          }
        ],
        :meta     => {
          :last_updated => "2023-01-01T12:00:00Z",
          :created_at   => "2022-01-01T12:00:00Z",
          :version      => {
            :major => 1,
            :minor => 2,
            :patch => 3
          }
        }
      }
      hash3 = {
        :personal       => {
          :name        => "John Doe",
          :age         => nil,
          :is_student  => false,
          :on_vacation =>
                          [
                            "2019-01-01"
                          ],
          :courses     => [
            {
              :name       => "Math 101",
              :topics     => ["Algebra", "Geometry", "Trigonometry"],
              :scores     => [90.5, 88.5, 75.0],
              :is_passing => true
            },
            {
              :name       => "History 201",
              :topics     => ["Renaissance", "World Wars", "Cold War"],
              :scores     => [],
              :is_passing => false
            }
          ]
        },
        :miscellaneous  => [
          "data",
          123,
          true,
          nil,
          {
            :random       => "value",
            :array_inside => ["value1", "value2"],
            :hash_inside  => {
              :key         => "value",
              :another_key => {
                :nested_key => "nested_value"
              }
            }
          },
          ["element1", "element2", "element3"]
        ],
        :floating_point => 123.456,
        :true_value     => true,
        :false_value    => false,
        :null_value     => nil,
        :empty_hash     => {},
        :empty_array    => []
      }
      puts hash1.to_beautiful_json(:align => true, :indent_size => 2)
    end
  end
end
