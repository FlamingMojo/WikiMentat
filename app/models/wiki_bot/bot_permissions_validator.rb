class WikiBot
  class BotPermissionsValidator < ActiveModel::Validator
    MINIMUM_PERMISSIONS = %w[
      bot ipblock-exempt editsemiprotected autopatrol autoconfirmed skipcaptcha read writeapi
      markbotedits noratelimit apihighlimits
      edit editcontentmodel minoredit changetags
      editprotected
      createtalk createpage move move-subpages move-rootuserpages suppressredirect
      upload
      movefile reupload-shared reupload
      blockemail block
      deletedhistory browsearchive deletedtext
      delete bigdelete nuke undelete
      protect
    ].uniq.freeze

    def validate(record)
      permissions_response = record.permissions

      record.errors.add(
        :base,
        "Bot login test failed. Error: #{permissions_response.errors}"
      ) unless permissions_response.success?

      rights = permissions_response.data['userinfo']['rights'].uniq
      missing_permissions = MINIMUM_PERMISSIONS - rights
      record.errors.add(:base, "The bot is missing permissions: #{missing_permissions}.") if missing_permissions.any?
    end
  end
end
