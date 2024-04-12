<?php

// Sample data storage (replace with a database in a real application)
$data = [];

// Function to output JSON response
function response($data, $status = 200) {
    header('Content-Type: application/json');
    http_response_code($status);
    echo json_encode($data);
    exit;
}

// Get the request method
$method = $_SERVER['REQUEST_METHOD'];

// Get the request path
$path = explode('/', trim($_SERVER['PATH_INFO'],'/'));

// Get the requested resource ID
$id = isset($path[0]) ? intval($path[0]) : null;

// Handle the request
switch ($method) {
    case 'GET':
        // If an ID is provided, return the resource with that ID
        if ($id !== null && isset($data[$id])) {
            response($data[$id]);
        }
        // If no ID is provided, return all resources
        response($data);
        break;
    case 'POST':
        // Read the input data
        $input = json_decode(file_get_contents('php://input'), true);
        // Add the data to the array
        $data[] = $input;
        response(['message' => 'Resource created'], 201);
        break;
    case 'PUT':
        // If no ID is provided, return an error
        if ($id === null || !isset($data[$id])) {
            response(['message' => 'Resource not found'], 404);
        }
        // Read the input data
        $input = json_decode(file_get_contents('php://input'), true);
        // Update the resource with the provided ID
        $data[$id] = $input;
        response(['message' => 'Resource updated']);
        break;
    case 'DELETE':
        // If no ID is provided, return an error
        if ($id === null || !isset($data[$id])) {
            response(['message' => 'Resource not found'], 404);
        }
        // Delete the resource with the provided ID
        unset($data[$id]);
        response(['message' => 'Resource deleted']);
        break;
    default:
        response(['message' => 'Method not allowed'], 405);
        break;
}
