{ rm, mk, nar, read, chdir, exists, expect } = require './lib/helper'
create = require '../lib/create'

describe 'create', ->

  dest = "#{__dirname}/fixtures/.tmp"

  describe 'basic', (_) ->

    before ->
      rm dest
      mk dest
      chdir "#{__dirname}/fixtures/basic"

    before ->
      @archive = create dest: dest

    after ->
      chdir "#{__dirname}/.."
      rm dest

    it 'should compress files sucessfully', (done) ->
      entries = 0
      @archive
        .on 'error', -> throw it
        .on 'entry', -> entries += 1
        .on 'end', ->
          expect it .to.be.equal "#{dest}/test-1.0.0.nar"
          expect entries > 7 .to.be.true
          done!

  describe 'complex', (_) ->

    before ->
      rm dest
      mk dest
      chdir "#{__dirname}/fixtures/complex/test"

    before ->
      @archive = create dest: dest

    after ->
      chdir "#{__dirname}/.."
      rm dest

    it 'should compress files sucessfully', (done) ->
      entries = 0
      @archive
        .on 'error', -> throw it
        .on 'entry', -> entries += 1
        .on 'end', ->
          expect it .to.be.equal "#{dest}/test-0.1.0-#{process.platform}-#{process.arch}.nar"
          expect entries > 10 .to.be.true
          done!

  describe 'global', (_) ->

    before ->
      rm dest
      mk dest
      chdir "#{__dirname}/fixtures/global"

    before ->
      @archive = create dest: dest

    after ->
      chdir "#{__dirname}/.."
      rm dest

    it 'should compress files sucessfully', (done) ->
      entries = 0
      @archive
        .on 'error', -> throw it
        .on 'entry', -> entries += 1
        .on 'end', ->
          expect it .to.be.equal "#{dest}/global-#{process.platform}-#{process.arch}.nar"
          expect entries > 100 .to.be.true
          done!

  describe 'binaryPath', (_) ->

    before ->
      rm dest
      mk dest
      chdir "#{__dirname}/fixtures/complex"

    before ->
      @archive = create {
        dest: dest
        binary: yes
        binaryPath: process.execPath
      }

    after ->
      chdir "#{__dirname}/.."
      rm dest

    it 'should compress files sucessfully', (done) ->
      entries = 0
      @archive
        .on 'error', -> throw it
        .on 'entry', -> entries += 1
        .on 'end', ->
          expect it .to.be.equal "#{dest}/test-0.1.0-#{process.platform}-#{process.arch}.nar"
          expect entries > 10 .to.be.true
          done!

  describe 'scoped', (_) ->

    before ->
      rm dest
      mk dest
      chdir "#{__dirname}/fixtures/scoped"

    before ->
      @archive = create { dest: dest }

    after ->
      chdir "#{__dirname}/.."
      rm dest

    it 'should compress files sucessfully', (done) ->
      entries = 0
      @archive
        .on 'error', -> throw it
        .on 'entry', -> entries += 1
        .on 'end', ->
          expect it .to.be.equal "#{dest}/test-0.1.0.nar"
          expect entries is 7 .to.be.true
          done!
