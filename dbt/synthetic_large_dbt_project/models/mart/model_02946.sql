{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01565') }},
        {{ ref('model_01909') }},
        {{ ref('model_01774') }}
)
select id, 'model_02946' as name from sources
