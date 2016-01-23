module Github
  autoload :Repository, 'github/repository'
  autoload :Utils, 'github/utils'

  # Custom exceptions
  class RepoNotFound < StandardError; end
end
