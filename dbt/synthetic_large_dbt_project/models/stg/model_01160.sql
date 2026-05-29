{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00739') }}
)
select id, 'model_01160' as name from sources
