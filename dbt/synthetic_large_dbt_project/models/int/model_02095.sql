{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01069') }},
        {{ ref('model_01158') }},
        {{ ref('model_01383') }}
)
select id, 'model_02095' as name from sources
