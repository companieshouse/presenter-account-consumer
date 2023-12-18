package uk.gov.companieshouse.presenter.account.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/presenter-account-consumer")
public class PresenterAccountConsumerController {

    @GetMapping("/healthcheck")
    public ResponseEntity<String> healthCheck(){
        return ResponseEntity.ok().body("OK");
    }
}