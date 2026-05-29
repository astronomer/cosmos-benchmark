{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02037') }},
        {{ ref('model_02210') }},
        {{ ref('model_01877') }}
)
select id, 'model_02698' as name from sources
