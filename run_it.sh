#!/usr/bin/env bash

if ! [ -e 2018StreetSweepingSchedule.pdf ]; then
  curl -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)" -sSL "https://www.toaks.org/home/showdocument?id=17160" > 2018StreetSweepingSchedule.pdf
fi

if ! [ -e 2018StreetSweepingSchedule_page_52_table_0.csv ]; then
  bundle install
  bundle exec iguvium 2018StreetSweepingSchedule.pdf
fi

if ! [ -e complete.csv ]; then
  rm contents.csv

  for csv_file in ./*.csv ; do
    tail -n +3 "${csv_file}" | grep -v "Weekly C" >> contents.csv
  done

  head -n 2 2018StreetSweepingSchedule_page_1_table_0.csv | tail -n 1 > headers.csv

  cat contents.csv | sort | cat headers.csv - > complete.csv
fi

bundle exec ruby process_it.rb
