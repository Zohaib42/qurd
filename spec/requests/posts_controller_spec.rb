require 'swagger_helper'

describe 'Posts API', type: :request, swagger_docs: 'v1/swagger.json' do
  let!(:member) { create :member, :with_following, :with_follower }
  let(:Authorization) { auth_headers(member) }
  let(:number_of_posts) { 20 }
  let!(:existing_posts) { create_list(:post, number_of_posts, creator: member.following.first) }

  context 'posts feed' do
    path "/posts" do
      get 'posts feed' do
        tags 'Posts'
        security [bearerAuth: []]
        operationId 'posts_feed'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :offset, in: :query

        context 'first' do
          response '200', 'Successfully return posts' do
            let(:start) { existing_posts.first.id }
            let(:ending) { start + number_of_posts }
            let(:mid) { (start + ending) / 2 }
            let(:offset) { nil }

            run_test! do
              expect(json_response["posts"].count).to eq 10
              expect(json_response["posts"].collect{|x| x["id"]}.reverse).to eq (mid..(ending-1)).to_a
            end
          end
        end

        context 'second' do
          response '200', 'Successfully return posts' do
            let(:start) { existing_posts.first.id }
            let(:ending) { start + number_of_posts }
            let(:mid) { (start + ending) / 2 }
            let(:offset) { mid+1 }

            run_test! do
              expect(json_response["posts"].count).to eq 10
              expect(json_response["posts"].collect{|x| x["id"]}.reverse).to eq ((start+1)..mid).to_a
            end
          end
        end

        context 'third' do
          response '200', 'Successfully return posts' do
            let(:start) { existing_posts.first.id }
            let(:ending) { start + number_of_posts }
            let(:mid) { (start + ending) / 2 }
            let(:offset) { nil }

            before do
              member.block_members.create(member_id: member.following.first.id)
            end

            run_test! do
              expect(json_response["posts"].count).to eq 0
            end
          end
        end
      end
    end
  end

  context 'creating new post' do
    path '/posts' do
      post 'Post create' do
        tags 'Posts'
        operationId 'create_post'
        security [bearerAuth: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_payload, in: :body, schema: { '$ref' => '#/definitions/post' }

        response '200', 'post created successfully' do
          let!(:device) { create :device, member: member.followers.first }
          let!(:notifications_count) { Rpush::Gcm::Notification.count }
          let(:post_payload) do
            {
              post: {
                title: 'FFaker::String',
                post_type: Post::POST_TYPES[:text],
                description: FFaker::String,
                share_type: Post::SHARE_TYPES[:link],
                link: 'www.google.com'
              }
            }
          end

          before { dump_rpush }

          run_test! do
            expect(json_response['post']['title']).to eq 'FFaker::String'
            expect(Rpush::Gcm::Notification.count).to eq notifications_count + 1
            expect(member.followers.first.notifications.count).to eq 1
          end
        end
      end
    end
  end

  context 'show post' do
    path '/posts/{id}' do
      get 'post show' do
        tags 'Posts'
        operationId 'show_post'
        security [bearerAuth: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let!(:new_post) { create :post }
          let!(:id) { new_post.id }

          run_test! do
            expect(json_response['id']).to eq new_post.id
          end
        end

        response '404', 'Returns not found response' do
          let!(:id) { 0 }

          run_test!
        end
      end
    end
  end

  context 'destroy post' do
    path '/posts/{id}' do
      delete 'destroy post' do
        tags 'Posts'
        operationId 'destroy_post'
        security [bearerAuth: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let!(:new_post) { create :post, creator: member }
          let(:id) { new_post.id }

          run_test! do
            expect(Post.exists?(id)).to eq false
          end
        end

        response '404', 'Returns not found response' do
          let(:id) { 0 }

          run_test!
        end
      end
    end
  end
end
