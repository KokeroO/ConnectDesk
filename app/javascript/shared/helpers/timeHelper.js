import {
  format,
  isSameYear,
  fromUnixTime,
  formatDistanceToNow,
} from 'date-fns';
import * as locales from 'date-fns/locale';
import dateFormatsByLocale from '../../dashboard/i18n/dateFormat';

const selectedLocale = (locale = 'en') => {
  return locales[locale.replace('-', '')]; // Fallback para enUS se o localeKey não existir
};

const formatPattern = (locale = 'en', formatType = 'standard') => {
  return (
    dateFormatsByLocale[locale.replace('-', '')]?.[formatType] ||
    dateFormatsByLocale.en[formatType]
  );
};

/**
 * Formats a Unix timestamp into a human-readable time format.
 * @param {number} time - Unix timestamp.
 * @param {string} [dateFormat='h:mm a'] - Desired format of the time.
 * @returns {string} Formatted time string.
 */
export const messageStamp = (time, formatType = 'timeOnly', locale = 'en') => {
  const unixTime = fromUnixTime(time);
  return format(unixTime, formatPattern(locale, formatType), {
    locale: selectedLocale(locale),
  });
};

/**
 * Provides a formatted timestamp, adjusting the format based on the current year.
 * @param {number} time - Unix timestamp.
 * @param {string} [dateFormat='MMM d, yyyy'] - Desired date format.
 * @returns {string} Formatted date string.
 */
export const messageTimestamp = (
  time,
  formatType = 'standard',
  locale = 'en'
) => {
  const messageTime = fromUnixTime(time);
  const now = new Date();
  const messageDate = format(messageTime, formatPattern(locale, formatType), {
    locale: selectedLocale(locale),
  });
  if (!isSameYear(messageTime, now)) {
    return format(messageTime, formatPattern(locale, formatType), {
      locale: selectedLocale(locale),
    });
  }
  return messageDate;
};

/**
 * Converts a Unix timestamp to a relative time string (e.g., 3 hours ago).
 * @param {number} time - Unix timestamp.
 * @returns {string} Relative time string.
 */
export const dynamicTime = (time, locale) => {
  const unixTime = fromUnixTime(time);
  return formatDistanceToNow(unixTime, {
    addSuffix: true,
    locale: selectedLocale(locale),
  });
};

/**
 * Formats a Unix timestamp into a specified date format.
 * @param {number} time - Unix timestamp.
 * @param {string} [dateFormat='MMM d, yyyy'] - Desired date format.
 * @returns {string} Formatted date string.
 */
export const dateFormat = (time, formatType = 'standard', locale = 'en') => {
  const unixTime = fromUnixTime(time);
  return format(unixTime, formatPattern(locale, formatType), {
    locale: selectedLocale(locale),
  });
};

/**
 * Converts a detailed time description into a shorter format, optionally appending 'ago'.
 * @param {string} time - Detailed time description (e.g., 'a minute ago').
 * @param {boolean} [withAgo=false] - Whether to append 'ago' to the result.
 * @returns {string} Shortened time description.
 */
export const shortTimestamp = (time, withAgo = false, locale = 'en') => {
  const unixTime = fromUnixTime(time);
  return formatDistanceToNow(unixTime, {
    addSuffix: withAgo,
    locale: selectedLocale(locale),
  });
};
