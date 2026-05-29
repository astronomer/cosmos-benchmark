{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01565') }},
        {{ ref('model_01635') }},
        {{ ref('model_02035') }}
)
select id, 'model_02355' as name from sources
