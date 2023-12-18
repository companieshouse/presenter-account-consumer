package uk.gov.companieshouse.presenter.account.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

public class PresenterAccountConsumerControllerTest {

    PresenterAccountConsumerController presenterAccountController;

    @BeforeEach
    void setUp() {
        presenterAccountController = new PresenterAccountConsumerController();
    }

    @Test
    @DisplayName("Return 200 on successfully health check")
    void test_HealthCheck_Endpoint_for_SuccessResponse (){
        var response = presenterAccountController.healthCheck();
        assertThat(response.getStatusCode(), is(HttpStatus.OK));
    }
}