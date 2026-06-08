-- Migration: Add reschedule/rejection reason columns to adoption_applications
-- Run this once against your database
 
ALTER TABLE `adoption_applications`
  ADD COLUMN `rejection_reason` ENUM('reschedule','requirements_not_met') NULL DEFAULT NULL AFTER `status`,
  ADD COLUMN `reschedule_date` DATE NULL DEFAULT NULL AFTER `rejection_reason`,
  ADD COLUMN `reschedule_time_start` TIME NULL DEFAULT NULL AFTER `reschedule_date`,
  ADD COLUMN `reschedule_time_end` TIME NULL DEFAULT NULL AFTER `reschedule_time_start`,
  ADD COLUMN `reschedule_token` VARCHAR(64) NULL DEFAULT NULL AFTER `reschedule_time_end`,
  ADD COLUMN `reschedule_response` ENUM('accepted','rejected') NULL DEFAULT NULL AFTER `reschedule_token`,
  ADD COLUMN `rejected_by_user_id` INT NULL DEFAULT NULL AFTER `reschedule_response`;
 
ALTER TABLE `adoption_applications`
  ADD INDEX `idx_reschedule_token` (`reschedule_token`);