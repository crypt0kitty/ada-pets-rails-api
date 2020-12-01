require "test_helper"

describe PetsController do
  describe "index" do
    it "responds with JSON and ok" do
      get pets_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end
  end

  it "responds with an array of pet hashes" do
    # Act
    get pets_path

    # Takes the body of the server's response and parses the JSON into regular Ruby arrays and hashes.
    body = JSON.parse(response.body)

    # Assert
    # Ensures that the response is an array
    expect(body).must_be_instance_of Array

    body.each do |pet|
      expect(pet).must_be_instance_of Hash
      # Ensures that each response has only the id, name, species, age, and owner fields
      required_pet_attrs = ["id", "name", "species", "age", "owner"]

      expect(pet.keys.sort).must_equal required_pet_attrs.sort
    end
  end
end
