{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02020') }},
        {{ ref('model_02029') }},
        {{ ref('model_01915') }}
)
select id, 'model_02344' as name from sources
