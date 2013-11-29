package com.recomdata.transmart.data.association

import grails.test.mixin.TestFor
import groovy.json.JsonSlurper

@TestFor(RModulesController)
class RModulesControllerTests {

    void "test that knownDataTypes gives back expected output for mrna"() {
        controller.knownDataTypes()
        JsonSlurper jsonSlurper = new JsonSlurper()
		Object result = jsonSlurper.parseText(controller.response.contentAsString)
        assert result.size() >= 3
        assert result["mrna"] != null
        assert result["mrna"].dataConstraints.size() > 0
        assert result["mrna"].assayConstraints.size() > 0
        assert result["mrna"].projections.size() > 0
    }

    void "test that knownDataTypes gives back expected output for mirna"() {
        controller.knownDataTypes()
        JsonSlurper jsonSlurper = new JsonSlurper()
		Object result = jsonSlurper.parseText(controller.response.contentAsString)
        assert result.size() >= 3
        assert result["mirna"] != null
        assert result["mirna"].dataConstraints.size() > 0
        assert result["mirna"].assayConstraints.size() > 0
        assert result["mirna"].projections.size() > 0
    }

    void "test that knownDataTypes gives back expected output for acgh"() {
        controller.knownDataTypes()
        JsonSlurper jsonSlurper = new JsonSlurper()
		Object result = jsonSlurper.parseText(controller.response.contentAsString)
        assert result.size() >= 3
        assert result["acgh"] != null
        assert result["acgh"].dataConstraints.size() > 0
        assert result["acgh"].assayConstraints.size() > 0
        assert result["acgh"].projections.size() > 0
    }
}
