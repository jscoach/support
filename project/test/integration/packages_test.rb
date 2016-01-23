require "test_helper"

class PackagesTest < ActionDispatch::IntegrationTest
  let(:user) { users :customer }

  before do
    # Authenticate the user
    login_as user, scope: :user

    Kaminari.configure do |config|
      config.default_per_page = 5
    end
  end

  it "shows all packages on root" do
    visit root_path
    current_path.must_equal packages_path
    page.must_have_content "package-1"
    page.title.must_equal "JS.coach"
  end

  it "starts with a welcome page" do
    visit "/collection-one"
    page.must_have_content "welcomes you!"
    page.title.must_equal "Collection One / JS.coach"
  end

  it "paginates the packages" do
    # There are 11 packages, 5 per page, so we have 3 pages

    visit "/collection-one"
    page.must_have_content "package-1"
    page.wont_have_content "package-6"
    page.has_link?("Previous").must_equal false # Must be a span

    click_link "Next"
    current_fullpath.must_equal packages_path(collection_id: "collection-one", page: 2)
    page.must_have_content "package-6"
    page.wont_have_content "package-1"

    click_link "Next"
    current_fullpath.must_equal packages_path(collection_id: "collection-one", page: 3)
    page.has_link?("Next").must_equal false

    click_link "Previous"
    click_link "Previous"
    current_fullpath.must_equal packages_path(collection_id: "collection-one")
    page.must_have_content "package-1"
    page.wont_have_content "package-6"
    page.has_link?("Previous").must_equal false

    page.title.must_equal "Collection One / JS.coach"
  end

  it "sorts the packages" do
    visit "/collection-one"

    page.body.must_match /package-1 .+ package-2/x
    page.body.wont_match /package-2 .+ package-1/x
    page.has_link?("Updated").must_equal false # Must be a span

    click_link "Popular"
    current_fullpath.must_equal packages_path(collection_id: "collection-one", sort: "popular")
    page.body.must_match /package-B .+ package-A/x
    page.body.wont_match /package-A .+ package-B/x
    page.has_link?("Popular").must_equal false

    click_link "New"
    current_fullpath.must_equal packages_path(collection_id: "collection-one", sort: "new")
    page.body.must_match /package-1 .+ package-2/x
    page.body.wont_match /package-2 .+ package-1/x
    page.body.wont_match /package-B .+ package-A/x # Those should be at the last page
    page.body.wont_match /package-A .+ package-B/x
    page.has_link?("New").must_equal false

    click_link "Updated"
    current_fullpath.must_equal packages_path(collection_id: "collection-one") # Default sorting
    page.body.must_match /package-1 .+ package-2/x
    page.body.wont_match /package-2 .+ package-1/x
    page.has_link?("Updated").must_equal false # Must be a span

    visit packages_path(collection_id: "collection-one", sort: "updated") # Adding param shouldn't change anything
    page.body.must_match /package-1 .+ package-2/x
    page.body.wont_match /package-2 .+ package-1/x
    page.has_link?("Updated").must_equal false # Must be a span

    page.title.must_equal "Collection One / JS.coach"
  end

  it "supports search", js: true do
    visit "/collection-one"
    page.wont_have_content "package-A"

    fill_in :search, with: "Package A"
    page.must_have_content "package-A"
    page.has_link?("Popular").must_equal false # The popular sorting option is selected

    fill_in_debounced :search, with: "Pack"
    click_link "New" # Sorting still works
    click_link "Next" # Pagination still works
    page.must_have_content "package-6"
    page.wont_have_content "package-B"

    expectedUrl = packages_path(collection_id: "collection-one", page: 2, sort: "new", search: "Pack")
    expectedUrl.url_must_equal current_fullpath

    fill_in_debounced :search, with: "Package" # The pagination resets but sorting does not
    expectedUrl = packages_path(collection_id: "collection-one", sort: "new", search: "Package")
    expectedUrl.url_must_equal current_fullpath

    click_link "Collection Two" # The user can change collections
    expectedUrl = packages_path(collection_id: "collection-two", sort: "new", search: "Package")
    expectedUrl.url_must_equal current_fullpath

    # When the user starts searching, sorting option changes to `popular`
    visit "/collection-two"
    click_link "New"
    current_fullpath.must_equal packages_path(collection_id: "collection-two", sort: "new")
    fill_in_debounced :search, with: "Package"
    current_fullpath.must_equal packages_path(collection_id: "collection-two", search: "Package")
    page.has_link?("Popular").must_equal false # The popular sorting option is selected

    page.title.must_equal "Collection Two / JS.coach"
  end

  it "shows the readme", js: true do
    visit "/collection-one"
    page.wont_have_content "ReadMe of package 1."

    click_link "package-1"
    page.must_have_content "ReadMe of package 1."
    page.title.must_equal "package-1 / JS.coach"
    click_link "package-2"
    page.wont_have_content "ReadMe of package 1."
    page.must_have_content "ReadMe of package 2."
    page.title.must_equal "package-2 / JS.coach"

    # The header of the details page also gets updated
    page.find("#details").wont_have_content /package-1 .+ by .+ repo\-user/x
    page.find("#details").must_have_content /package-2 .+ by .+ repo\-user/x

    # It doesn't clear existing query params
    click_link "New"
    page.must_have_content "ReadMe of package 2."
    current_fullpath.must_equal package_path(collection_id: "collection-one",
      id: "package-2", sort: "new")
    click_link "package-1"
    page.must_have_content "ReadMe of package 1."
    current_fullpath.must_equal package_path(collection_id: "collection-one",
      id: "package-1", sort: "new")

    # And it also works on initial render
    visit "/collection-one/package-1"
    page.find("#details").must_have_content /package-1 .+ by .+ repo\-user/x
  end
end
