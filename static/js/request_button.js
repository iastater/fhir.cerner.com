/**
 * Displays the response from the request below the button.
 * @param {object} response - The response from the endpoint call. 
 * @param {HTMLElement} button - The request button for the current example.
 */
function displayResult(response, button) {
  let responseDiv = document.createElement('div');
  responseDiv.dataset.id = button.id;

  let responseHeader = document.createElement('h4');
  responseHeader.innerText = 'Live Response';

  let statusPre = document.createElement('pre');
  statusPre.className = 'headers';

  let statusCode = document.createElement('code');
  statusCode.innerText = 'Status: 200 OK';
  statusPre.appendChild(statusCode);

  let responsePre = document.createElement('pre');
  responsePre.className = 'body-response';

  let responseCode = document.createElement('code');
  responseCode.className = 'language-javascript';
  responseCode.innerText = JSON.stringify(response, null, 2);
  responsePre.appendChild(responseCode);

  responseDiv.appendChild(responseHeader);
  responseDiv.appendChild(statusPre);
  responseDiv.appendChild(responsePre);

  button.parentNode.parentNode.insertBefore(responseDiv, button.parentNode.nextSibling.nextSibling);
}

/**
 * Displays a loading spinner below the button while the request processes.
 * @param {HTMLElement} button - The request button for the current example. 
 */
function displayLoadingSpinner(button) {
  let template = document.createElement('template');
  let loadingSpinnerHTML = '<div class="loading-spinner"><div></div><div></div><div></div><div></div></div>';
  template.innerHTML = loadingSpinnerHTML.trim();

  let loadingSpinner = template.content.firstChild;
  button.parentNode.parentNode.insertBefore(loadingSpinner, button.parentNode.nextSibling);
}

/**
 * Displays a failure message for calls that do not return a 200 or that return an empty bundle.
 * @param {object} xhr - The response object returned from the request. 
 * @param {bool} emptyBundle - Whether or not the response returned an empty bundle.
 */
function showRequestFailureMessage(xhr = null, emptyBundle = false) {
  let button = document.getElementById(buttonId);

  if (button.parentNode.nextElementSibling.className === 'loading-spinner') {
    button.parentNode.nextElementSibling.classList.toggle('hide');
  }

  let failureMessage = document.createElement('div');
  failureMessage.className = 'failure-message';

  if (emptyBundle) {
    let failureText = document.createElement('p');
    failureText.innerText = 'Unfortunately, this request returned no results. To view what a request containing ' +
                            'results might look like, please view the example response below.\n' +
                            `X-Request-Id: ${xhr.getResponseHeader('X-Request-Id')}`;

    failureMessage.appendChild(failureText);
  }
  else {
    let beforeAnchor = document.createElement('p');
    beforeAnchor.innerText = 'Failed to make this request: If this issue persists, please post to our ';

    let anchor = document.createElement('a');
    anchor.innerText = 'developer group';
    anchor.href = 'https://groups.google.com/d/forum/cerner-fhir-developers';

    let afterAnchor = document.createElement('p');
    afterAnchor.innerText = ` with\nX-Request-Id: ${xhr.getResponseHeader('X-Request-Id')}`;

    failureMessage.appendChild(beforeAnchor);
    failureMessage.appendChild(anchor);
    failureMessage.appendChild(afterAnchor);
  }

  button.parentNode.parentNode.insertBefore(failureMessage, button.parentNode.nextSibling);
}

/**
 * Toggles between the live response returned from the request and the example response.
 * @param {string} buttonId - The id of the button for the current example. 
 */
function toggleExampleResponse(buttonId) {
  let exampleResponse = document.getElementById(buttonId).parentNode.nextElementSibling.nextElementSibling;

  if (document.querySelectorAll(`div[data-id="${buttonId}"]`).length != 0) {
    let showExampleAnchor = document.getElementById(buttonId).nextElementSibling;
    let liveResponse = document.getElementById(buttonId).parentNode.nextElementSibling.nextElementSibling;
    exampleResponse = exampleResponse.nextElementSibling;

    if (showExampleAnchor.innerText === 'Show Example Response') {
      showExampleAnchor.innerText = 'Show Live Response';
    }
    else showExampleAnchor.innerText = 'Show Example Response';

    liveResponse.classList.toggle('hide');
  }

  exampleResponse.classList.toggle('hide');
}

/**
 * Makes a GET request using the provided URL and displays the result.
 * If the request fails or returns an empty bundle, an error message is displayed instead.
 * @param {string} url - The URL of the endpoint to call.
 * @param {string} acceptHeader - The accept header associated with the request.
 * @param {HTMLElement} button - The request button for the current example. 
 */
function makeRequest(url, acceptHeader, button) {
  // Make button id accessible for failed requests
  window.buttonId = button.id;

  if (button.parentNode.nextElementSibling.classList.contains('loading-spinner') === false) {
    displayLoadingSpinner(button);

    let header = { Accept: acceptHeader };

    fetchData(url, header, true, function(response, xhr) {
      if (button.dataset.status != xhr.status) {
        showRequestFailureMessage(xhr, false);
      }
      else if (response.resourceType === 'Bundle' && !response.hasOwnProperty('entry')) {
        showRequestFailureMessage(xhr, true);
      }
      else {
        let loadingSpinner = button.parentNode.nextElementSibling;
        loadingSpinner.classList.toggle('hide');

        // Display example toggle
        button.nextElementSibling.classList.toggle('hide');
        toggleExampleResponse(buttonId);

        displayResult(response, button);
      }
    }, showRequestFailureMessage);
  }

  button.disabled = true;
}
