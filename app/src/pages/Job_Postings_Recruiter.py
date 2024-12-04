import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_job_postings_card"):
    ui.element("h2", children=["Manage Job Postings"], className="text-2xl font-bold text-gray-800", key="view_job_postings_title")
    ui.element("div", children=["\n\n"], key="view_job_postings_divider")
    ui.element("p", children=["View, add, update, and delete student profiles."], className="text-gray-600")

data = {} 
try:
    data = requests.get('http://api:4000/s/students').json()
    ui.element("h3", children=["Students"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  
    
def deleteStudent(student_id, student_name):
    try:
        response = requests.delete(f'http://api:4000/s/students/{student_id}')
        if response.status_code == 200:
            logger.info(f"Student deleted: {student_id}")
            ui.alert_dialog(
            show=True, 
            title="Deleted Student", 
            description=f"The student profile under the name {student_name} has been deleted.", 
            confirm_label="OK", 
            cancel_label="Cancel", 
            key=f"delete_dialog_{student_id}"
            )
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to delete student: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"delete_student_error_{student_id}"
            )
    except Exception as e:
        logger.error(f"Error deleting student {student_id}: {str(e)}")
        ui.element(
            "p",
            children=["Failed to delete student: Unknown error"],
            className="text-red-500",
            key=f"delete_student_error_{student_id}"
        )


def updateStudent(student_id, updated_data):
    try:
        response = requests.put(
            f'http://api:4000/s/students/{student_id}',
            json=updated_data
        )
        if response.status_code == 200:
            logger.info(f"Student updated successfully: {student_id}")
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to update student: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"update_student_error_{student_id}"
            )
    except Exception as e:
        logger.error(f"Error updating student {student_id}: {str(e)}")
        ui.element(
            "p",
            children=["Failed to update student: Unknown error"],
            className="text-red-500",
            key=f"update_student_error_{student_id}"
        )


def StudentProfileCard(student):
    with ui.element("div", key=f"student_card_{student['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element("h3", children=[f"Name: {student['name']}"], className="text-xl font-bold text-gray-800")
        ui.element("p", children=[f"Email: {student['email']}"], className="text-gray-600")
        ui.element("p", children=[f"GPA: {student['gpa']}"], className="text-gray-600")
        ui.element("p", children=[f"Major: {student['major_name']}"], className="text-gray-600")
        ui.element("p", children=[f"Grad Year: {student['grad_year']}"], className="text-gray-600")
        ui.element("p", children=[f"Advised By: {student['advisor_name']}"], className="text-gray-600")

    col1, col2, col3, col4, col5, col6, col7, col8 = st.columns(8)

    with col1:
        updateBtn = ui.button("Update", className="bg-purple-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_student_{student['id']}")
        if updateBtn:
            st.session_state['updating_student_id'] = student['id']
            st.switch_page('pages/Update_Student.py')


    with col2:
        deleteBtn = ui.button("Delete", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"delete_student_{student['id']}")
        if deleteBtn:
            deleteStudent(student['id'], student['name'])
           


if data and isinstance(data, list):
    if data:
        for student in data:
            StudentProfileCard(student)
    else:
        ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")
