require "controllers/api/v1/test"

class Api::V1::ItemsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @item = build(:item, team: @team)
      @other_items = create_list(:item, 3)
      # 🚅 super scaffolding will insert file-related logic above this line.
      @item.save

      @another_item = create(:item, team: @team)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(item_data)
      # Fetch the item in question and prepare to compare it's attributes.
      item = Item.find(item_data["id"])

      assert_equal_or_nil item_data['name'], item.name
      assert_equal_or_nil item_data['content'], item.content
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal item_data["team_id"], item.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/items", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      item_ids_returned = response.parsed_body.map { |item| item["id"] }
      assert_includes(item_ids_returned, @item.id)

      # But not returning other people's resources.
      assert_not_includes(item_ids_returned, @other_items[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/items/#{@item.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/items/#{@item.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      item_data = JSON.parse(build(:item, team: nil).to_api_json)
      item_data.except!("id", "team_id", "created_at", "updated_at")
      params[:item] = item_data

      post "/api/v1/teams/#{@team.id}/items", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/items",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/items/#{@item.id}", params: {
        access_token: access_token,
        item: {
          name: 'Alternative String Value',
          content: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @item.reload
      assert_equal @item.name, 'Alternative String Value'
      assert_equal @item.content, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/items/#{@item.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Item.count", -1) do
        delete "/api/v1/items/#{@item.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/items/#{@another_item.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
