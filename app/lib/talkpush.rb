module Talkpush
  extend self

  class TalkpushError < StandardError; end
  class MissingCandidateFieldError < TalkpushError; end
  class RequestError < TalkpushError; end
end