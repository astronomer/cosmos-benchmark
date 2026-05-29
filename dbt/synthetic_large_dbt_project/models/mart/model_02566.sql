{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01662') }},
        {{ ref('model_02075') }}
)
select id, 'model_02566' as name from sources
