module GoogleApi
  class GoogleSheet
    SPREADSHEET_KEY = "1xkofJa5iI3AQE4yWEoHqMTQ1QQ-VDsfUDDwV96QQDVM".freeze

    def self.read
      session = GoogleDrive::Session.from_service_account_key('client_secrets.json')

      spreadsheet = session.spreadsheet_by_key(SPREADSHEET_KEY)
      worksheet = spreadsheet.worksheets.first

      worksheet.rows.drop(1)
    end
  end
end
