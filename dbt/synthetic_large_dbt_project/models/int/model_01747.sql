{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01204') }},
        {{ ref('model_00989') }},
        {{ ref('model_01371') }}
)
select id, 'model_01747' as name from sources
