{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01360') }},
        {{ ref('model_01245') }},
        {{ ref('model_00865') }}
)
select id, 'model_02035' as name from sources
