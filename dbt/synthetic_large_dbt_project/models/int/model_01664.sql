{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00861') }},
        {{ ref('model_01086') }}
)
select id, 'model_01664' as name from sources
