<?php
namespace Cme;

class Authentication {
    /**
     * Middleware invokable class for authenticating a user
     *
     * @param  \Psr\Http\Message\ServerRequestInterface $request  PSR7 request
     * @param  \Psr\Http\Message\ResponseInterface      $response PSR7 response
     * @param  callable                                 $next     Next middleware
     *
     * @return \Psr\Http\Message\ResponseInterface
     */
    public function __invoke($request, $response, $next)
    {
         if($request->isGet()) {
            // No authentication needed.
            // Go ahead and move on to the actual request.
            $request = $request->withAttribute('user', false);
            $response = $next($request, $response);
            return $response;
        }
        // set any routes you don't want to worry about
        $exclusions = ['/api/v1/interactions'];
        if(in_array($request->getUri()->getPath(), $exclusions)) {
            // No authentication needed.
            // Go ahead and move on to the actual request.
            $response = $next($request, $response);
            return $response;
        }

        // passed data
        $data = $request->getParsedBody();
        $errors = [];

        if(!$request->hasHeader('X-API-Access') || !$request->hasHeader('X-API-Client')) {
            throw new \Error('No user passed.');
        } else {
            $clientToken = $request->getHeader('X-API-Client')[0];
            $accessToken = $request->getHeader('X-API-Access')[0];
            // validate the user
            $validUser = Utility\validateUserToken($clientToken, $accessToken);

            if($validUser !== true) {
                throw new \Error('Invalid user.');
            }
        }

        if(!empty($errors)) {
            $response->getBody()->write(json_encode($errors));
            return $response;
        }

        // add in our valid user to the request
        $request = $request->withAttribute('user', Utility\getUser('clientToken', $clientToken));
        // go ahead and move on to the actual request
        $response = $next($request, $response);
        return $response;
    }
}
