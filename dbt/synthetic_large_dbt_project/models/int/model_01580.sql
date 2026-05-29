{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01206') }},
        {{ ref('model_00835') }}
)
select id, 'model_01580' as name from sources
