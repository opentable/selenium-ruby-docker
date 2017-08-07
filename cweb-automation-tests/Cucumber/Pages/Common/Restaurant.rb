class Restaurant

    attr_accessor :rid, :domain, :db

    def initialize(rid,domain = $domain)
      @rid = rid
      @domain = domain
      make_db_connection()
    end

    def make_db_connection()
      @db = OTDBAction.new(@domain.db_server_address, @domain.db_name, $db_user_name, $db_password)
    end

    def change_restaurant_data(field,value)
      case field
        when 'MinPartySize'
          colname = 'MinOnlineOptionID'
        when 'MaxPartySize'
          colname = 'MaxLargePartyID'
        when 'RestStateID'
          colname = 'RestStateID'
        when 'AdvanceBookingOption'
          colname = 'MaxAdvanceOptionID'
        when 'AcceptLargeParty'
          colname = 'AcceptLargeParty'
        else
          puts "no change"
      end
      sql= "update Restaurant set #{colname} = #{value} where RID = #{@rid}"
      @db.runquery_no_result_set(sql)
    end

    def change_to_active_but_not_reachable
      sql= "update Restaurant set RestStateID=1, IsReachable = 0 where RID = #{@rid}"
      @db.runquery_no_result_set(sql)
    end

    def add_blocked_day(rid, fwd_days)
      blocked_date = DateTime.now + Integer(fwd_days)
      blocked_date_str = blocked_date.strftime("%Y-%m-%d")
      sql= "exec dbo.Admin_AddUpdateDeleteBlockedDayDefault #{rid}, '#{blocked_date_str}', 'automationtest'"
      @db.runquery_no_result_set(sql)
    end

    def unblock_all_days(rid)
      sql= "exec dbo.Admin_BlockDays_Delete #{rid}, 1, null"
      @db.runquery_no_result_set(sql)
    end

    def set_early_cutoff(rid, cut_off_days)
      if (cut_off_days.to_i > 0)
        sql = "insert RestaurantSuppression (RID, RestaurantSuppressionTypeId, SuppressionDays) VALUES (#{rid}, 4, #{cut_off_days})"
        @db.runquery_no_result_set(sql)
      end
    end

    def set_early_cancellation_cutoff(rid, cut_off_days)
      if (cut_off_days.to_i > 0)
        sql = "insert RestaurantSuppression (RID, RestaurantSuppressionTypeId, SuppressionDays) VALUES (#{rid}, 1, #{cut_off_days})"
        @db.runquery_no_result_set(sql)
      end
    end

    def set_same_day_cutoff(rid, cutoff_time)
      cd = "1900-01-01 " + cutoff_time
      c = cd.to_datetime
      cutoff_string =  c.strftime("%Y-%m-%dT%H:%M:00")
      sql = "EXEC dbo.Admin_ReservationCutoff_Add #{rid}, 2,'#{cutoff_string}', '1900-01-01 23:59:59', 1, 'Dinner', '1,2,3,4,5,6,7'"
      @db.runquery_return_resultset(sql)
    end

    def remove_same_day_cutoff(rid)
      sql= "delete from ScheduleShifts where RID = #{rid}"
      @db.runquery_no_result_set(sql)
      sql= "delete from ShiftTemplate where RID = #{rid}"
      @db.runquery_no_result_set(sql)
    end

    def remove_search_early_cutoff_days(rid)
       sql= "delete from RestaurantSuppression where RID = #{rid} and RestaurantSuppressionTypeId = 4"
       @db.runquery_no_result_set(sql)
    end

    def remove_early_cancellation_cutoff(rid)
      sql= "delete from RestaurantSuppression where RID = #{rid} and RestaurantSuppressionTypeId = 1"
      @db.runquery_no_result_set(sql)
    end

    def set_cc_day_time_ps(rid, ccDateOffset, cc_start_time, cc_end_time, cc_ps)
      ccDate = DateTime.now + Integer(ccDateOffset)
      ccDate = ccDate.strftime("%Y-%m-%d")
      sql= "DECLARE @rc int = 0; EXEC Admin_CCDays_AddUpdate 0, #{rid}, '#{ccDate}', '1900-01-01 #{cc_start_time}', '1900-01-01 #{cc_end_time}', #{cc_ps}, 'automation', 'CC day', 1, @rc"
      @db.runquery_return_resultset(sql)
    end

    def delete_cc_days(rid)
      sql= "EXEC Admin_CCDays_Delete #{rid}, 1, null"
      @db.runquery_no_result_set(sql)
    end

    def set_cc_day(rid, cc_day_offset)
      ccDate = DateTime.now + Integer(cc_day_offset)
      ccDate = ccDate.strftime("%Y-%m-%d")
      sql= "DECLARE @rc int = 0; EXEC Admin_CCDays_AddUpdate 0, #{rid}, '#{ccDate}', null, NULL, 1, 'automation', 'CC day', 1, @rc"
      @db.runquery_return_resultset(sql)
    end

    def set_credit_card_party_size_threshold(rid, cc_PartySize_limit)
      sql= "UPDATE Restaurant set AcceptLargeParty=1, MinCCOptionID=#{cc_PartySize_limit} where RID = #{rid}"
      @db.runquery_no_result_set(sql)
    end

    def createPOPSuppressDay(suppressDay_offset)
        suppressDate = DateTime.now + suppressDay_offset.to_i
        suppressDate = suppressDate.strftime("%Y-%m-%d")
        #--- verify POP suppress day exist for requested date --
        sql = "select  count(*) from IncentiveSuppressDay where RID = #{rid} and SuppressedDate = '#{suppressDate}' and Active = 1"
        result_set = @db.runquery_return_resultset(sql)
        suppress_day_exist = result_set[0][0].to_i
        if (suppress_day_exist == 0)
            sql= "select IncHistID from dbo.IncentiveHistory where RID = #{rid}"
            result_set = @db.runquery_return_resultset(sql)
            incHistID = result_set[0][0]
            sql = "EXEC	[dbo].[Incentive_InsertSuppressedDays]
                  @RID = #{rid},
                  @SuppressedDate = '#{suppressDate}',
                  @IncHistID = #{incHistID}"
            @db.runquery_return_resultset(sql)
        end
    end

    def removePOPSuppressday(suppressDay_offset)
        suppressDate = DateTime.now + suppressDay_offset.to_i
        suppressDate = suppressDate.strftime("%Y-%m-%d")
        #--- verify POP suppress day exist for test date --
        sql = "select  count(*) from IncentiveSuppressDay where RID = #{rid} and SuppressedDate = '#{suppressDate}' and Active = 1"
        result_set = @db.runquery_return_resultset(sql)
        suppress_day_exist = result_set[0][0].to_i
        if (suppress_day_exist != 0)
            sql =  "select  IncSuppressID,ActiveIncHistID from IncentiveSuppressDay where RID = #{rid} and SuppressedDate = '#{suppressDate}' and Active = 1"
            result_set = @db.runquery_return_resultset(sql)
            incSuppressID = result_set[0][0]
            incHistID  =  result_set[0][1]
            sql = "EXEC	 [dbo].[Incentive_UpdateSuppressedDays]
                @RID = #{rid},
                @IncSuppressID = #{incSuppressID},
                @IncHistID = #{incHistID}"
            @db.runquery_return_resultset(sql)
      end
  end

  def createHoliday(holiday_date,holiday_name,suppress_POP)
      sql = "EXEC	[dbo].[Admin_Holiday_AddAllLanguages]
          @Holiday_Names = '#{holiday_name}',
          @LanguageIDs = '1',
          @Holiday_Date = '#{holiday_date}',
          @CountryID = 'US',
          @SuppressDIP = #{suppress_POP}"
      @db.runquery_return_resultset(sql)
  end

  def removeHoliday(holidayID)
      sql = "select DateId from HolidaySchedule where HolidayID = #{holidayID}"
      result_set = @db.runquery_return_resultset(sql)
      dateId = result_set[0][0]
      sql = "EXEC	[dbo].[Admin_Holiday_Delete]
                @Date_ID = #{dateId}"
      @db.runquery_return_resultset(sql)
      sql = "delete from HolidaysLocal where HolidayID = #{holidayID}"
      @db.runquery_return_resultset(sql)
      sql = "delete from Holidays where HolidayID = #{holidayID}"
      @db.runquery_return_resultset(sql)
  end

  def add_same_day_pop_threshhold(rid, pop_threshHoldTime, pop_start_time, pop_end_time)
      sql =  "EXEC	[dbo].[Incentive_DataLoadLastMinutePOP]
              @RID = #{rid},
              @LastMinutePOPThresholdTime = '#{pop_threshHoldTime}',
              @POPStartTime = '1900-01-01 #{pop_start_time}',
              @POPEndTime = '1900-01-01 #{pop_end_time}'"
    @db.runquery_return_resultset(sql)
  end

  def remove_same_day_pop_threshhold(rid)
      sql = "select distinct(ActiveIncHistID)  from incentive where rid= #{rid} and LastMinutePopThresholdTime IS NOT NULL and Active = 1"
      result_set = @db.runquery_return_resultset(sql)
      if (result_set.length != 0 )
         activeIncHistID = result_set[0][0]
         sql = "update Incentive set Active = 0 where RID = #{rid} and ActiveIncHistID = #{activeIncHistID}"
         @db.runquery_return_resultset(sql)
      end
  end

  def add_remove_restaurant_to_promo(rid,pid,active)
    sql =  "EXEC	[dbo].[Admin_Promos_Pages_AddRest]
                      @PromoID = #{pid},
                  		@RestID = #{rid},
                  		@ShortDesc = 'Test',
                  		@Message = 'Test',
                  		@Reserve = 'Test',
                  		@rank = 1,
                  		@active = #{active}"
    @db.runquery_return_resultset(sql)
  end

  def set_restaurant_promo_shifts(rid, pid, lunchBit, dinnerBit)
    sql =  "update PromoRests set Lunch = #{lunchBit}, Dinner = #{dinnerBit} where RID = #{rid} and PromoID = #{pid}"
    @db.runquery_return_resultset(sql)
  end


  def change_promo_data(pid, status,suppress_dip_flag, expiryDate = '9999-12-31 00:00:00.000', promoSearchTypeId = 3)
      sql = "update PromoPages set
            active = #{status},
            EndDate = '#{expiryDate}',
            EventEndDate  = '#{expiryDate}',
            SuppressDIP = #{suppress_dip_flag},
            PromoSearchTypeID = #{promoSearchTypeId}
        where PromoID = #{pid}"
      @db.runquery_return_resultset(sql)
  end

  def change_promo_exclusion_date(pid, exclusion_date)
     sql = "Insert PromoPageExclusions (PromoID, ExclusionDate) values (#{pid}, '#{exclusion_date}')"
     @db.runquery_return_resultset(sql)
  end

  def remove_promo_exclusion_date(pid)
       sql = "delete from PromoPageExclusions where promoid = #{pid} and ExclusionDate IS NOT NULL  "
       @db.runquery_return_resultset(sql)
  end

  def setting_partial_promo_DIP_supress_exclusion(pid,rid,lunch_bit,dinner_bit)
      sql = "INSERT PromoDIPSupressExclusion VALUES (#{pid}, #{rid}, #{lunch_bit},#{dinner_bit}, 'automation')"
      @db.runquery_return_resultset(sql)
  end

  def remove_partial_promo_DIP_supress_exclusion(pid)
      sql = "delete from PromoDIPSupressExclusion where promoid = #{pid}"
      @db.runquery_return_resultset(sql)
  end

  def blacklist_erb_for_direct_searches(rid)
    lookupId = 66
    sql = "insert ValueLookupIDList (LookupID, ValueID) values (#{lookupId}, #{rid})"
    @db.runquery_return_resultset(sql)
  end

  def unblacklist_erb_for_direct_searches(rid)
    lookupId = 66
    sql = "delete ValueLookupIDList where LookupID = #{lookupId} and ValueID = #{rid}"
    @db.runquery_return_resultset(sql)
  end
  
  def remove_restaurant_link_to_all_promos(rid)
    sql = "delete from PromoRestLocal where RID = #{rid};delete from PromoRestCore where RID = #{rid}"
    @db.runquery_return_resultset(sql)
  end

  def get_restaurant_localDateTime(rid)
    sql =  "select t.currentLocalTime
            from Restaurant r
            inner join TimezoneVW t
            on r.TZID = t.TZID
            where r.RID = #{rid}"
    result_set = @db.runquery_return_resultset(sql)
    return result_set[0][0]
  end

end