import os
import csv

# Directory containing the CSV files
CSV_DIR = "database-files/csv"  # Replace with the path to your directory

# Table-to-file mapping (update these mappings)
TABLE_FILES = {
    "college": "colleges.csv",  # 1. No foreign keys
    "industry": "industries.csv",  # 2. No foreign keys
    "department": "departments.csv",  # 3. Depends on 'college'
    "major": "majors.csv",  # 4. Depends on 'department'
    "coop_advisor": "advisors.csv",  # 5. Depends on 'department'
    "company": "companies.csv",  # 6. Depends on 'industry'
    "hiring_manager": "hiring_manager.csv",  # 7. Depends on 'company'
    "job_position": "job_positions.csv",  # 8. Depends on 'company'
    "student": "students.csv",  # 9. Depends on 'major', 'coop_advisor', 'hiring_manager', and optionally 'job_position'
    "hiring_manager_coop_advisor": "hiring_manager_coop_advisor.csv",  # 10. Depends on 'hiring_manager' and 'coop_advisor'
    "student_past_job": "student_past_jobs.csv",  # 11. Depends on 'student' and 'job_position'
    "review": "reviews.csv",  # 12. Depends on 'student' and 'job_position'
    "interview_question": "interview_questions.csv",  # 13. Depends on 'job_position' and 'student'
    "application": "applications.csv",  # 14. Depends on 'student' and 'job_position'
    "skill": "skills.csv",  # Independent, can be inserted at any time
}


# Output file for generated MySQL code
OUTPUT_SQL_FILE = "insert_data.sql"

def generate_mysql_insert(table_name, file_path):
    """Generate SQL INSERT statements for a given table and CSV file."""
    insert_statements = []
    with open(file_path, 'r', encoding='utf-8') as csv_file:
        csv_reader = csv.reader(csv_file)
        headers = next(csv_reader)  # First row contains column names
        column_names = ", ".join(headers)

        for row in csv_reader:
            # Escape single quotes in values
            values = [f"'{value.replace('\'', '\\\'')}'" if isinstance(value, str) else f"{value}" for value in row]
            values_str = ", ".join(values)
            insert_statements.append(f"INSERT INTO {table_name} ({column_names}) VALUES ({values_str});")
    
    return insert_statements

def main():
    all_insert_statements = []

    # Iterate through each table and its corresponding CSV file
    for table, file_name in TABLE_FILES.items():
        file_path = os.path.join(CSV_DIR, file_name)
        if os.path.exists(file_path):
            print(f"Generating SQL for table: {table} from file: {file_name}")
            insert_statements = generate_mysql_insert(table, file_path)
            all_insert_statements.extend(insert_statements)
        else:
            print(f"File not found: {file_name}")
    
    # Write all generated SQL code to the output file
    with open(OUTPUT_SQL_FILE, 'w', encoding='utf-8') as sql_file:
        sql_file.write("\n".join(all_insert_statements))
    
    print(f"MySQL INSERT statements have been written to {OUTPUT_SQL_FILE}")

if __name__ == "__main__":
    main()
