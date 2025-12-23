# Library Management System

A simple Library Management System built in x86 Assembly language (8086) for DOS. This application allows Admins to manage books and students, and Students to borrow and return books.

## Features

The system is divided into two main modules: **Admin** and **Student**.

### Admin Module
*   **Login**: Secure login for administrators.
*   **Add Student**: Register new students into the system.
*   **Add Book**: Add new books to the library inventory.
*   **Delete Student**: Remove a student from the records.
*   **Delete Book**: Remove a book from the library.
*   **Display All Books**: View a list of all available books.

### Student Module
*   **Login**: Secure login for students.
*   **Read Book**: Open and read a specific book file (text file).
*   **Borrow Book**: Borrow a book from the library (logs transaction).
*   **Return Book**: Return a borrowed book.
*   **Display All Books**: View available books.

## File Structure
*   `library System.asm`: Main source code file.
*   `admins.txt`: Stores admin credentials (`User_ID|Username|Password`).
*   `students.txt`: Stores student credentials (`User_ID|Username|Password`).
*   `books.txt`: Stores book information (`Book_ID|Book_Name`).
*   `transactions.txt`: Logs borrowing transactions (`User_ID|Book_ID`).

## Usage
1.  Upon running, choose your role: `1` for Admin or `2` for Student.
2.  Enter your credentials to log in.
3.  Select an operation from the menu by entering the corresponding number.

## Technical Details
*   **Data Persistence**: Records are saved in `.txt` files.
*   **Deletion Logic**: Deleting a record replaces it with dashes (`-`) to maintain file alignment without expensive file rewrite operations.
*   **Input Format**: inputs are processed and stored with a `|` delimiter.
