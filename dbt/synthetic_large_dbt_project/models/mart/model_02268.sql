{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01910') }},
        {{ ref('model_01807') }},
        {{ ref('model_01541') }}
)
select id, 'model_02268' as name from sources
