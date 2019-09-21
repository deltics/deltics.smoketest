# Introduction 
A lightweight testing framework, named for the "Continuity Tester" electrical testing equipment, used to simply test for a continuous, closed circuit.

# Getting Started - Duget Package
To use this library simply add `continuity` to your project .duget file and run `duget update` to obtain the latest version available in any of your feeds (duget.org is recommended).

# Build and Test
The build pipeline for this package compiles a set of self-tests with every version of Delphi.  These tests use Continuity itself and do not use Smoketest or any other testing framework. The results are still produced in xUnit 2.x format and so may be published in Azure DevOps for code quality metrics.