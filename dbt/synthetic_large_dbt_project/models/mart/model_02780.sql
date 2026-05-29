{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01842') }},
        {{ ref('model_02127') }}
)
select id, 'model_02780' as name from sources
