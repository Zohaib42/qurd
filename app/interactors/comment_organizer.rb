class CommentOrganizer
  include Interactor::Organizer

  organize CreateCommentInteractor, TagsNotifyInteractor
end
