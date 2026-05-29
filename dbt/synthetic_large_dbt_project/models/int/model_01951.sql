{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00866') }},
        {{ ref('model_00930') }}
)
select id, 'model_01951' as name from sources
