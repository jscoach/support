require "test_helper"

class PackageTest < ActiveSupport::TestCase
  before do
    Rails.application.load_seed
  end

  it "resets a custom repo if a new from NPM is available" do
    pkg = Package.new(original_repo: "original/repo")
    pkg.repo.must_equal "original/repo"

    pkg.repo = "custom/repo"
    pkg.original_repo.must_equal "original/repo"
    pkg.repo.must_equal "custom/repo"

    pkg.original_repo = "new_original/repo"
    pkg.original_repo.must_equal "new_original/repo"
    pkg.repo.must_equal "new_original/repo"
    pkg.read_attribute(:repo).must_be_nil
  end

  it "supports custom descriptions" do
    pkg = Package.new(original_description: "Original description.")
    pkg.description.must_equal "Original description."

    # Preserves the original description
    pkg.description = "Custom description."
    pkg.original_description.must_equal "Original description."
    pkg.description.must_equal "Custom description."

    # Updates the custom description
    pkg.original_description = "New original description."
    pkg.original_description.must_equal "New original description."
    pkg.description.must_equal "New original description."

    # Avoids repetition
    pkg.original_description = "New original description."
    pkg.description = "New original description."
    pkg.read_attribute(:description).must_be_nil
  end
end
