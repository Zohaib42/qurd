# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_dry_run = false
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      basePath: '/api/v1',
      paths: {},
      definitions: {
        login: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string }
          },
          required: %w[email password],
          example: {
            sign_in: {
              email: 'nkdev@oxford.edu.eng',
              password: 'password'
            }
          }
        },
        reset_password_link: {
          type: :object,
          properties: {
            email: { type: :string }
          },
          example: {
            email: 'nkdev@oxford.edu.eng'
          }
        },
        account_change_password: {
          type: :object,
          properties: {
            old_password: { type: :string },
            password: { type: :string },
            confirm_password: { type: :string }
          },
          required: %w[first_name last_name email mobile],
          example: {
            "account": {
              old_password: 'P4ssw0rd#!',
              password: 'w0rdP4ss#!',
              password_confirmation: 'w0rdP4ss#!'
            }
          }
        },
        account_update: {
          type: :object,
          properties: {
            first_name: { type: :string },
            last_name: { type: :string },
            mobile: { type: :string }
          },
          example: {
            "account": {
              first_name: 'Samuel',
              last_name: 'Black',
              mobile: '+33 4 55 44 33'
            }
          }
        },
        change_password: {
          type: :object,
          properties: {
            password: { type: :string },
            password_confirmation: { type: :string },
            current_password: { type: :string }
          },
          example: {
            password: 'example',
            password_confirmation: 'example',
            current_password: 'password'
          }
        },
        sign_up: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string },
            name: { type: :string },
            username: { type: :string },
            mobile: { type: :string },
            website_url: { type: :string }
          },
          required: %w[email password name username mobile],
          example: {
            sign_up: {
              email: 'nkdev@oxford.edu.eng',
              password: 'password',
              name: 'Samuel Black',
              username: 'samuelblack1',
              mobile: '(555) 555-1234',
              website_url: 'example.com'
            }
          }
        },
        rsvp: {
          type: :object,
          properties: {
            event_id: { type: :integer }
          },
          example: {
            rsvp: {
              event_id: 1
            }
          }
        },
        onboarding: {
          type: :object,
          properties: {
            member_attributes: {
              type: :object,
              properties: {
                pronouns: { type: :string },
                website_url: { type: :string },
                image: { type: :file },
                star_sign: { type: :string },
              }
            },
            skills: { type: :array },
            interests: { type: :array }
          },
          example: {
            onboarding: {
              member_attributes: {
                pronouns: 'He/Him',
                website_url: 'example.com',
                star_sign: 'Aries',
                image: 'file/attachment'
              },
              skills:    ['Rapper', 'Singing', 'dancing'],
              interests: ['director', 'producer', 'choreographer']
            }
          }
        },
        members: {
          type: :object,
          properties: {
            term: { type: :string },
            skills: { type: :array },
            looking_for_skills: { type: :array },
            college_id: { type: :integer }
          },
          example: {
            term: "abc",
            skills: [1, 2],
            looking_for_skills: [1,2],
            college_id: 1
          }
        },
        follow_member: {
          type: :object,
          properties: {
            member_id: { type: :integer }
          },
          example: {
            member_id: 1
          }
        },
        post: {
          type: :object,
          properties: {
            title: { type: :string },
            post_type: { type: :string },
            description: { type: :text },
            attachment: { type: :file },
          },
          example: {
            post: {
              title: 'abc',
              post_type: Post::POST_TYPES[:image],
              description: 'xyz',
              attachment: 'this-is-sample-attribute-will-not-work-with-swagger',
              share_type: Post::SHARE_TYPES[:link],
              link: 'https://www.google.com'
            }
          }
        },
        comment: {
          type: :object,
          properties: {
            content: { type: :text },
            member_ids: { type: :array }
          },
          example: {
            comment: {
              content: 'abc',
              tagged_member_ids: [1,2]
            }
          }
        },
        share: {
          type: :object,
          properties: {},
          example: {
            share: {}
          }
        },
        leave_group: {
          type: :object,
          properties: {
            member_id: :integer
          },
          example: {
            leave_group: {
              member_id: 1
            }
          }
        },
        group: {
          type: :object,
          properties: {
            name: { type: :string },
            image: { type: :file },
            chat_type: { type: :string },
            member_ids: { type: :array }
          },
          example: {
            group: {
              name: 'abc',
              image: 'file-attachment',
              chat_type: Group::CHAT_TYPES[:channel],
              member_ids: [1, 2]
            }
          }
        },
        device: {
          type: :object,
          properties: {
            token: { type: :string },
            platform: { type: :string }
          },
          example: {
            device: {
              token: 'Abcd#1234',
              platform: 'android'
            }
          }
        },
        post_report: {
          type: :object,
          properties: {
            reason: { type: :text },
            post_id: { type: :integer }
          },
          example: {
            post_report: {
              reason: 'abc',
              post_id: 1
            }
          }
        },
        member_report: {
          type: :object,
          properties: {
            reason: { type: :text },
            reporter_id: { type: :integer }
          },
          example: {
            member_report: {
              reason: 'abc',
              reported_id: 1
            }
          }
        },
        block_member: {
          type: :object,
          properties: {
            member_id: { type: :integer }
          },
          example: {
            block_member: {
              member_id: 1
            }
          }
        },
        bulk_follow: {
          type: :object,
          properties: {
            member_ids: { type: :array }
          },
          example: {
            bulk_follow: {
              member_ids: [1, 2]
            }
          }
        },
      },
      securityDefinitions: {
        bearerAuth: {
          type: 'apiKey',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          in: 'header',
          description: 'JWT Authorization header using the Bearer scheme. Example: Authorization: Bearer {token}',
          name: 'Authorization'
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json
end
