import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_student_card"):
    ui.element("h2", children=["Student Profiles"], className="text-2xl font-bold text-gray-800", key="view_students_title")
    ui.element("div", children=["\n\n"], key="view_students_divider")
    ui.element("p", children=["Search student profiles by major."], className="text-gray-600")

majors = []
try:
    majors = requests.get('http://api:4000/m/majors').json()
except Exception as e:
    logger.error(f"Error retrieving company data: {e}")
    majors = []

major_options = {major['name']: major["id"] for major in majors}
desired_major = ui.select(options=list(major_options.keys()), label="Select a major:")
desired_major_id = major_options.get(desired_major)

students_data = []
if desired_major_id:
    try:
        students_data = requests.get(f'http://api:4000/s/students/major/{desired_major_id}').json()
        logger.info(f"Retrieved students data for major ID: {desired_major_id}")
        logger.info(f"Students data: {students_data}")
    except Exception as e:
        logger.error(f"Error retrieving students data: {e}")
        students_data = []

def StudentCard(student):
    with ui.element("div", key=f"student_card_{student['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element("h3", children=[f"Name: {student['name']}"], className="text-xl font-bold text-gray-800")
        ui.element("p", children=[f"Email: {student['email']}"], className="text-gray-600")
        ui.element("p", children=[f"GPA: {student['gpa']}"], className="text-gray-600")
        ui.element("p", children=[f"Major: {student['major_name']}"], className="text-gray-600")
        ui.element("p", children=[f"Grad Year: {student['grad_year']}"], className="text-gray-600")
        ui.element("p", children=[f"Advised By: {student['advisor_name']}"], className="text-gray-600")
        if student['past_job'] is not None:
            ui.element("p", children=[f"Past Job: {student['past_job_name']}"], className="text-gray-600")
        else:
            ui.element("p", children=[f"Past Job: N/A"], className="text-gray-600")


if students_data and isinstance(students_data, list):
    if students_data:
        for student in students_data:
            StudentCard(student)
    else:
        ui.element("h3", children=["No students available for this major"], className="text-xl font-bold text-gray-800")
else:
    logger.error("Failed to load student data or invalid major selected")
    ui.element("h3", children=["Failed to load student data or invalid major selected"], className="text-xl font-bold text-gray-800")
