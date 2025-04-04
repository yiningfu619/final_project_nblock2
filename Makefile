final_report.html: final_report.Rmd code/render_report.R .data
	Rscript code/render_report.R

.data: code/data_cleaning.R autism_prevalence_studies_20250220.csv
	Rscript code/data_cleaning.R

.PHONY: clean
clean:
	rm output/*.RDS && rm final_report.html