{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01015') }},
        {{ ref('model_01013') }},
        {{ ref('model_00766') }}
)
select id, 'model_02134' as name from sources
