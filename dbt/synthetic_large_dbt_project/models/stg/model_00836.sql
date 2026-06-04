{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00206') }},
        {{ ref('model_00642') }}
)
select id, 'model_00836' as name from sources
