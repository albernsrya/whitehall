require 'test_helper'

class Admin::InternationalPrioritiesControllerTest < ActionController::TestCase

  setup do
    @user = login_as :policy_writer
  end

  should_be_an_admin_controller

  should_allow_showing_of :international_priority
  should_allow_creating_of :international_priority
  should_allow_editing_of :international_priority
  should_allow_revision_of :international_priority

  should_show_document_audit_trail_for :international_priority, :show
  should_show_document_audit_trail_for :international_priority, :edit

  should_allow_association_between_world_locations_and :international_priority
  should_allow_association_with_worldwide_offices :international_priority
  should_allow_attached_images_for :international_priority
  should_allow_organisations_for :international_priority

  should_be_rejectable :international_priority
  should_be_publishable :international_priority
  should_allow_unpublishing_for :international_priority
  should_be_force_publishable :international_priority
  should_be_able_to_delete_an_edition :international_priority
  should_link_to_public_version_when_published :international_priority
  should_not_link_to_public_version_when_not_published :international_priority
  should_link_to_preview_version_when_not_published :international_priority
  should_prevent_modification_of_unmodifiable :international_priority
  should_allow_access_limiting_of :international_priority

  view_test 'show displays a link to add a new translation' do
    edition = create(:draft_international_priority)

    get :show, id: edition

    assert_select "a[href=#{new_admin_edition_translation_path(edition)}]", text: "Add"
  end

  view_test "show displays all non-english translations" do
    edition = create(:draft_international_priority, title: 'english-title', summary: 'english-summary', body: 'english-body')
    with_locale(:fr) { edition.update_attributes!(title: 'french-title', summary: 'french-summary', body: 'french-body') }

    get :show, id: edition

    assert_select "#translations" do
      refute_select '.title', text: 'english-title'
      refute_select '.summary', text: 'english-summary'
      refute_select '.body', text: 'english-body'
      assert_select '.title', text: 'french-title'
      assert_select '.summary', text: 'french-summary'
      assert_select '.body', text: 'french-body'
    end
  end
end
